class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect "/users/#{current_user.slug}?error=You are already logged in."
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
      erb :'users/signup'  # view can access @user in order to display validation failures to user with error messages
    end
  end

  get '/login' do
    if logged_in?
      redirect "/users/#{current_user.slug}?error=You are already logged in."
    else
      @error_message = params[:error]
      erb :'users/login'
    end
  end

  post '/login' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/users/#{current_user.slug}"
    else
      # error message displayed in view if user name and password are not valid
      redirect '/login?error=The Name and Password combination is not valid. Please try again or sign up.'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/login?error=You are already logged out.'
    end
  end

  get '/users/:slug' do
    redirect_if_not_logged_in
    @error_message = params[:error]
    @user = User.find_by_slug(params[:slug])
    # user may only view its own show page which lists the babies under its care
    if @user && @user.id == current_user.id
      erb :'users/show'
    else
      redirect "/users/#{current_user.slug}?error=You may only view your own home page."
    end
  end

end
