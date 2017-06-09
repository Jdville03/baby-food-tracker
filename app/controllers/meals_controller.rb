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
    meal.delete if meal && current_user.babies.include?(meal.baby)
    redirect "/babies/#{meal.baby.slug}"
  end

  get '/meals/:slug/new' do
    
  end

  post '/meals/:slug/new' do

  end

end
