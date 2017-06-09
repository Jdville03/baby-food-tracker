class MealsController < ApplicationController

  get '/meals' do

  end

  get '/meals/:id' do
    redirect_if_not_logged_in
    @meal = Meal.find_by_id(params[:id])
    # user may only view meal of baby that belongs to user
    if @meal && current_user.babies.include?(@meal.baby)
      erb :'meals/show'
    else
      redirect "/users/#{current_user.slug}?error=You may only view entries for your own babies."
    end
  end

  get '/meals/:slug/new' do

  end

  post '/meals/:slug/new' do

  end

  get '/meals/:id/edit' do
    redirect_if_not_logged_in
    @meal = Meal.find_by_id(params[:id])
    # user may only view meal of baby that belongs to user
    if @meal && current_user.babies.include?(@meal.baby)
      erb :'meals/edit'
    else
      redirect "/users/#{current_user.slug}?error=You may only view entries for your own babies."
    end
  end

  patch '/meals/:id/edit' do

  end

  delete '/meals/:id/delete' do

  end


end
