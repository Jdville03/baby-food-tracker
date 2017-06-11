class BabiesController < ApplicationController

  get '/babies/new' do
    redirect_if_not_logged_in
    erb :'babies/new'
  end

  get '/babies/existing' do
    redirect_if_not_logged_in
    @error_message = params[:error]
    erb :'babies/existing'
  end

  post '/babies/new' do
    redirect_if_not_logged_in
    @baby = current_user.babies.create(params)
    if @baby.save
      redirect "/users/#{current_user.slug}"
    else
      # view can access @baby in order to display validation failures with error messages
      erb :'babies/new'
    end
  end

  post '/babies/existing' do
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
      redirect '/babies/existing?error=The Name and PIC combination is not valid. Please try again.'
    end
  end

  get '/babies/:slug' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_slug(params[:slug])
    # user may only view show page of baby that belongs to the user
    if @baby
      @last_meal = @baby.meals.sort_by{|meal| [meal.entry_date, meal.entry_time]}.last
      @last_size = @baby.sizes.sort_by{|size| size.entry_date}.last
      erb :'babies/show'
    else
      redirect "/users/#{current_user.slug}?error=You may only view your own babies."
    end
  end

  delete '/babies/:slug/delete' do
    redirect_if_not_logged_in
    baby = current_user.babies.find_by_slug(params[:slug])
    # user may only remove baby from own profile (baby will still remain visible to its other users)
    if baby
      current_user.babies.delete(baby)
      redirect "/users/#{current_user.slug}"
    else
      redirect "/users/#{current_user.slug}?error=You may only remove your own babies from the list of babies under your care."
    end
  end



  # GET: /babies/5/edit
  get "/babies/:id/edit" do
    erb :"/babies/edit"
  end

  # PATCH: /babies/5
  patch "/babies/:id" do
    redirect "/babies/:id"
  end

end
