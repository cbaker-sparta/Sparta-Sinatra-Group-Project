require 'pg'

class Specs

  attr_accessor(:spec_id, :spec_name)

  def self.open_connection

    connection = PG.connect(dbname: 'sparta_db')

  end

  def self.all
    connection = self.open_connection

    sql = "SELECT * FROM spec"
    results = connection.exec(sql)
    specs = results.map do |spec|
      self.hydrate(spec)

    end

    specs

  end

  def self.find(spec_id)
    connection = self.open_connection

    sql = "SELECT * FROM spec WHERE spec_id = #{spec_id} LIMIT 1"
    specs = connection.exec(sql)
    spec = self.hydrate(specs[0])
    spec
  end

  def self.hydrate(spec_data)
    spec = Specs.new

    spec.spec_id = spec_data['spec_id']
    spec.spec_name = spec_data['spec_name']

    spec

  end


  def save
    connection = Specs.open_connection

    if (!self.spec_id)
      sql = "INSERT INTO spec (spec_name) VALUES ('#{self.spec_name}')"
    else
      sql = "UPDATE spec SET spec_name='#{self.spec_name}' WHERE spec_id='#{self.spec_id}'"
    end
    connection.exec(sql)
  end

  def self.check_id(id)

    connection = self.open_connection
    sql = " SELECT spec_id FROM cohorts WHERE spec_id = #{id}"

    results = connection.exec(sql)
    specs = results.map do |result|
      self.hydrate result
    end
    specs.length

  end


  def self.destroy(spec_id)
    connection = self.open_connection
    sql = "DELETE FROM spec WHERE spec_id = #{spec_id}"
    connection.exec(sql)
  end


end
