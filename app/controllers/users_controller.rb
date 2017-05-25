class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect "/users/#{current_user.slug}"
    else
      erb :'/users/signup'
    end
  end

  post '/signup' do
    @user = User.new(params)
    if @user.save
      session[:user_id] = @user.id
      redirect "/users/#{current_user.slug}"
    else
      #redirect :'/users/signup'
      erb :'/users/signup'  # view can access @user in order to display password_confirmation validation failure to user with error message
    end
  end

  get '/login' do
    if logged_in?
      redirect "/users/#{current_user.slug}"
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/users/#{current_user.slug}"
    else
      erb :'/users/login', locals: {message: "The Name and Password combination is not valid. Please try again."}
    end
  end
  
  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end


  # GET: /users
  get "/users" do
    erb :"/users/index"
  end

  # GET: /users/new
  get "/users/new" do
    erb :"/users/new"
  end

  # POST: /users
  post "/users" do
    redirect "/users"
  end

  # GET: /users/5
  get "/users/:id" do
    erb :"/users/show"
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    erb :"/users/edit"
  end

  # PATCH: /users/5
  patch "/users/:id" do
    redirect "/users/:id"
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    redirect "/users"
  end
end
