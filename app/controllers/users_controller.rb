class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect "/users/#{current_user.slug}"
    else
      erb :'users/signup'
    end
  end

  post '/signup' do
    @user = User.new(params)
    if @user.save
      session[:user_id] = @user.id
      redirect "/users/#{current_user.slug}"
    else
      erb :'users/signup'  # view can access @user in order to display password_confirmation validation failure to user with error message
    end
  end

  get '/login' do
    if logged_in?
      redirect "/users/#{current_user.slug}"
    else
      erb :'users/login'
    end
  end

  post '/login' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/users/#{current_user.slug}"
    else
      erb :'users/login', locals: {message: "The Name and Password combination is not valid. Please try again."}
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

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    if @user.id == current_user.id
      erb :'users/show'
    else  # user may only view its own show page which lists the babies under its care
      redirect "/users/#{current_user.slug}"
    end
  end

end
