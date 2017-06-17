class BabiesController < ApplicationController

  get '/babies/new' do
    redirect_if_not_logged_in
    erb :'babies/new'
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

  get '/babies/existing' do
    redirect_if_not_logged_in
    erb :'babies/existing'
  end

  post '/babies/existing' do
    redirect_if_not_logged_in
    if @baby = Baby.find_by(name: params[:name], birthdate: params[:birthdate]).try(:authenticate, params[:password])
      if current_user.babies.include?(@baby)
        # error message displayed in view if existing baby being added already belongs to the user
        redirect "/users/#{current_user.slug}?error=The baby you attempted to add is already included in your profile."
      else
        current_user.babies << @baby
        redirect "/users/#{current_user.slug}"
      end
    else
      # error message displayed in view if name, birthdate, and password (PIP) combination is not valid
      @error_message = "The entered information is not valid for an existing baby. Please try again."
      # new instance created to allow form in view to include previously entered data on subsequent attempts to add an existing baby after validation error
      @baby = Baby.new(params)
      erb :'babies/existing'
    end
  end

  get '/babies/:id' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_id(params[:id])
    # user may only view show page of baby that belongs to the user
    if @baby
      @last_meal = @baby.meals.sort_by{|meal| [meal.entry_date, meal.entry_time]}.last
      @last_size = @baby.sizes.sort_by{|size| size.entry_date}.last
      erb :'babies/show'
    else
      redirect "/users/#{current_user.slug}?error=You may only view your own babies."
    end
  end

  delete '/babies/:id/delete' do
    redirect_if_not_logged_in
    baby = current_user.babies.find_by_id(params[:id])
    # user may only remove baby from own profile (baby will still remain visible to its other users)
    if baby
      current_user.babies.delete(baby)
      redirect "/users/#{current_user.slug}"
    else
      redirect "/users/#{current_user.slug}?error=You may only remove your own babies from the list of babies under your care."
    end
  end

  get '/babies/:id/edit' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_id(params[:id])
    # user may only edit show page of baby that belongs to the user
    if @baby
      @last_meal = @baby.meals.sort_by{|meal| [meal.entry_date, meal.entry_time]}.last
      @last_size = @baby.sizes.sort_by{|size| size.entry_date}.last
      erb :'babies/edit'
    else
      redirect "/users/#{current_user.slug}?error=You may only edit information for your own babies."
    end
  end

  patch "/babies/:id" do
    redirect_if_not_logged_in
    baby = current_user.babies.find_by_id(params[:id])
    # user may only edit show page of baby that belongs to the user
    if baby
      baby.update(birthdate: params[:birthdate])
      redirect "/babies/#{baby.id}"
    else
      redirect "/users/#{current_user.slug}?error=You may only edit information for your own babies."
    end
  end

end
