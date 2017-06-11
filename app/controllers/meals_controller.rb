class MealsController < ApplicationController

  get '/meals' do

  end

  get '/meals/:id/edit' do
    redirect_if_not_logged_in
    @meal = Meal.find_by_id(params[:id])
    # user may only view meal of baby that belongs to user
    if @meal && current_user.babies.include?(@meal.baby)
      erb :'meals/edit'
    else
      redirect "/users/#{current_user.slug}?error=You may only view and edit entries for your own babies."
    end
  end

  patch '/meals/:id/edit' do
    redirect_if_not_logged_in
    @meal = Meal.find_by_id(params[:id])
    # user may only edit meal of baby that belongs to user
    if @meal && current_user.babies.include?(@meal.baby)
      @meal.entry_date = params[:entry_date]
      @meal.entry_time = params[:entry_time]
      @meal.food_type = params[:food_type]
      @meal.duration = params[:duration]
      @meal.amount = params[:amount]
      @meal.ingredients = params[:ingredients]
      @meal.notes = params[:notes]
      if @meal.save
        redirect "/babies/#{@meal.baby.slug}"
      else
        # view can access @meal in order to display validation failures with error messages
        erb :'meals/edit'
      end
    else
      redirect "/users/#{current_user.slug}?error=You may only view and edit entries for your own babies."
    end
  end

  delete '/meals/:id/delete' do
    redirect_if_not_logged_in
    meal = Meal.find_by_id(params[:id])
    # user may only delete meal of baby that belongs to user
    if meal && current_user.babies.include?(meal.baby)
      meal.delete
      redirect "/babies/#{meal.baby.slug}"
    else
      redirect "/users/#{current_user.slug}?error=You may only delete entries for your own babies."
    end
  end

  get '/meals/:slug/new' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_slug(params[:slug])
    # user may only add meal for baby that belongs to user
    if @baby
      erb :'meals/new'
    else
      redirect "/users/#{current_user.slug}?error=You may only add entries for your own babies."
    end
  end

  post '/meals/:slug/new' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_slug(params[:slug])
    # user may only add meal for baby that belongs to user
    if @baby
      @meal = @baby.meals.create(params[:meal])
      if @meal.save
        redirect "/babies/#{@baby.slug}"
      else
        # view can access @baby and @meal in order to display validation failures with error messages
        erb :'meals/new'
      end
    else
      redirect "/users/#{current_user.slug}?error=You may only add entries for your own babies."
    end
  end

end
