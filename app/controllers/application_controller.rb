require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'babymealssecret'
  end

  get '/' do
    erb :welcome
    #redirect "/users/#{current_user.slug}"
  end

  helpers do

    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def redirect_if_not_logged_in
      if !logged_in?
        redirect '/login?error=Please log in to continue to your requested page.'
      end
    end

  end

end
