class SpecsController < Sinatra::Base

  set :root, File.join(File.dirname(__FILE__), '..')
  set :views, Proc.new {File.join(root, "views")}

  configure :development do
    register Sinatra::Reloader
  end

  register do
    def auth (type)
      condition do
        redirect "/" unless session[:email]
      end
    end
  end

  get "/specs", :auth => true do
      @specs = Specs.all
      erb :'specs/index'
  end

  get "/specs/new", :auth => true do
    @spec = Specs.new
    erb :'specs/new'
  end

  get "/specs/:id", :auth => true do
    spec_id = params[:id].to_i
    @spec = Specs.find(spec_id)
    erb :'specs/show'
  end

  get "/specs/:id/edit", :auth => true do
    spec_id = params[:id].to_i
    @spec = Specs.find(spec_id)
    erb :'specs/edit'
  end

  post "/specs/", :auth => true do
    spec = Specs.new
    spec.spec_name = params[:spec_name]
    spec.save
    redirect "/specs"
  end

  put "/specs/:id", :auth => true do
    spec_id = params[:id].to_i
    spec = Specs.find(spec_id)
    spec.spec_name = params[:spec_name]
    spec.save
    redirect "/specs"
  end

  delete "/specs/:id", :auth => true do
    id = params[:id].to_i
    @check = Specs.check_id(id)
    if (@check == 0)
      Specs.destroy(id)
      redirect "/specs"
    else
      @error_message = "Error, Specialisation in use."
      @spec = Specs.find(id)
      erb :"specs/show"
    end
  end

end
