class UsersController < ApplicationController

  use Rack::Flash

  get '/signup' do
    if logged_in?
      redirect "/users/#{current_user.slug}?error=You are already logged in."
    else
      erb :'users/signup'
    end
  end

  post '/signup' do
    @user = User.create(params)
    if @user.save
      session[:user_id] = @user.id
      redirect "/users/#{current_user.slug}"
    else
      erb :'users/signup'
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
    if user = User.find_by(username: params[:username]).try(:authenticate, params[:password])
      session[:user_id] = user.id
      redirect "/users/#{current_user.slug}"
    else
      redirect '/login?error=The Username and Password combination is not valid. Please try again or sign up.'
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
    if @user && @user.id == current_user.id
      erb :'users/show'
    else
      redirect "/users/#{current_user.slug}?error=You may only view your own home page."
    end
  end

end
