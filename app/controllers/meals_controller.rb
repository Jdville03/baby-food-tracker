class MealsController < ApplicationController

  get '/meals/:id/edit' do
    redirect_if_not_logged_in
    @meal = Meal.find_by_id(params[:id])
    if @meal && current_user.babies.include?(@meal.baby)
      erb :'meals/edit'
    else
      redirect "/users/#{current_user.slug}?error=You may only view and edit entries for your own babies."
    end
  end

  patch '/meals/:id/edit' do
    redirect_if_not_logged_in
    @meal = Meal.find_by_id(params[:id])
    if @meal && current_user.babies.include?(@meal.baby)
      if @meal.update_with_data(params)
        redirect "/meals/#{@meal.baby.id}"
      else
        erb :'meals/edit'
      end
    else
      redirect "/users/#{current_user.slug}?error=You may only view and edit entries for your own babies."
    end
  end

  delete '/meals/:id/delete' do
    redirect_if_not_logged_in
    meal = Meal.find_by_id(params[:id])
    if meal && current_user.babies.include?(meal.baby)
      meal.delete
      redirect "/meals/#{meal.baby.id}"
    else
      redirect "/users/#{current_user.slug}?error=You may only delete entries for your own babies."
    end
  end

  get '/meals/:baby_id' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_id(params[:baby_id])
    if @baby
      @meals = @baby.meals.select{|meal| meal.entry_date == Date.current}
      @time_frame = "today"
      erb :'meals/index'
    else
      redirect "/users/#{current_user.slug}?error=You may only view entries for your own babies."
    end
  end

  post '/meals/:baby_id' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_id(params[:baby_id])
    if @baby
      @meals = @baby.meals_by_time_frame(params[:time_frame])
      @time_frame = params[:time_frame]
      erb :'meals/index'
    else
      redirect "/users/#{current_user.slug}?error=You may only view entries for your own babies."
    end
  end

  get '/meals/:baby_id/new' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_id(params[:baby_id])
    if @baby
      erb :'meals/new'
    else
      redirect "/users/#{current_user.slug}?error=You may only add entries for your own babies."
    end
  end

  post '/meals/:baby_id/new' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_id(params[:baby_id])
    if @baby
      @meal = @baby.meals.create(params[:meal])
      @meal.amount_type = nil if !@meal.amount
      if @meal.save
        redirect "/meals/#{@baby.id}"
      else
        erb :'meals/new'
      end
    else
      redirect "/users/#{current_user.slug}?error=You may only add entries for your own babies."
    end
  end

end
