class BabiesController < ApplicationController

  # GET: /babies
  #get "/babies" do
  #  erb :"/babies/index"
  #end

  # GET: /babies/new
  get '/babies/add-new' do
    redirect_if_not_logged_in
    erb :'babies/add_new'
  end

  get '/babies/add-existing' do
    redirect_if_not_logged_in
    @error_message = params[:error]
    erb :'babies/add_existing'
  end

  post '/babies/add-new' do
    redirect_if_not_logged_in
    @baby = current_user.babies.create(params)
    if @baby.save
      redirect "/users/#{current_user.slug}"
    else
      # view can access @baby in order to display validation failures with error messages
      erb :'babies/add_new'
    end
  end

  post '/babies/add-existing' do
    redirect_if_not_logged_in
    if baby = Baby.find_by(name: params[:name]).try(:authenticate, params[:password])
      if current_user.babies.include?(baby)
        # error message displayed in view if existing baby being added already belongs to the user
        redirect "/users/#{current_user.slug}?error=The baby you attempted to add is already included in your profile."
      else
        current_user.babies << baby
        redirect "/users/#{current_user.slug}"
      end
    else
      # error message displayed in view if name and password (PIC) are not valid
      redirect '/babies/add-existing?error=The Name and PIC combination is not valid. Please try again.'
    end
  end

  get '/babies/:slug' do
    redirect_if_not_logged_in
    #@error_message = params[:error]
    @baby = current_user.babies.find_by_slug(params[:slug])
    # user may only view show page of baby that belongs to the user
    if @baby
      erb :'babies/show'
    else
      redirect "/users/#{current_user.slug}?error=You may only view your own babies."
    end
  end

  #get '/babies/:slug/size/:id/edit' do
  #  redirect_if_not_logged_in
  #  @baby = current_user.babies.find_by_slug(params[:slug])
  #  if @baby
  #    erb :'sizes/edit'
  #  else
  #    redirect "/users/#{current_user.slug}?error=You may only add or edit entries for your own babies."
  #  end
  #end

  #patch '/babies/:slug' do
  #  redirect_if_not_logged_in
  #  baby = current_user.babies.find_by_slug(params[:slug])
  #  if baby
  #    baby.sizes.update_all
#
  #  else
#
  #  end
  #end

  delete '/babies/:slug/delete' do
    redirect_if_not_logged_in
    baby = current_user.babies.find_by_slug(params[:slug])
    # user may only remove baby from own profile (baby will still remain visible to its other users)
    current_user.babies.delete(baby.id) if baby
    redirect "/users/#{current_user.slug}"
  end


  # POST: /babies
  #post "/babies" do
  #  redirect "/babies"
  #end

  # GET: /babies/5
  #get "/babies/:id" do
  #  erb :"/babies/show"
  #end

  # GET: /babies/5/edit
  get "/babies/:id/edit" do
    erb :"/babies/edit"
  end

  # PATCH: /babies/5
  patch "/babies/:id" do
    redirect "/babies/:id"
  end

  # DELETE: /babies/5/delete
  #delete "/babies/:id/delete" do
  #  redirect "/babies"
  #end
end
