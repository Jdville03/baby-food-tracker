class MealsController < ApplicationController

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
      case @meal.food_type
      when "breast milk (breast)"
        @meal.duration = params[:duration]
      when "breast milk (bottle)"
        @meal.amount = params[:amount]
        @meal.amount_type = params[:amount_type]
      when "formula"
        @meal.amount = params[:amount]
        @meal.amount_type = params[:amount_type]
      when "solids"
        @meal.ingredients = params[:ingredients]
        @meal.amount = params[:amount]
        # when amount is optional: if user selects amount_type without entering an amount, amount_type is set to nil
        @meal.amount ? @meal.amount_type = params[:amount_type] : @meal.amount_type = nil
      end
      @meal.notes = params[:notes]
      if @meal.save
        redirect "/meals/#{@meal.baby.id}"
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
      redirect "/meals/#{meal.baby.id}"
    else
      redirect "/users/#{current_user.slug}?error=You may only delete entries for your own babies."
    end
  end

  get '/meals/:baby_id' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_id(params[:baby_id])
    # user may only view meals for baby that belongs to user
    if @baby
      # default view of meals is today
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
    # user may only view meals for baby that belongs to user
    if @baby
      case params[:time_frame]
      when "today"
        @meals = @baby.meals.select{|meal| meal.entry_date == Date.current}
        @time_frame = "today"
      when "last_3_days"
        @meals = @baby.meals.select{|meal| meal.entry_date > Date.current - 3}
        @time_frame = "last_3_days"
      when "week"
        @meals = @baby.meals.select{|meal| meal.entry_date.cweek == Date.current.cweek && meal.entry_date.cwyear == Date.current.cwyear}
        @time_frame = "week"
      when "last_7_days"
        @meals = @baby.meals.select{|meal| meal.entry_date > Date.current - 7}
        @time_frame = "last_7_days"
      when "month"
        @meals = @baby.meals.select{|meal| meal.entry_date.month == Date.current.month && meal.entry_date.year == Date.current.year}
        @time_frame = "month"
      when "all"
        @meals = @baby.meals
        @time_frame = "all"
      end
      erb :'meals/index'
    else
      redirect "/users/#{current_user.slug}?error=You may only view entries for your own babies."
    end
  end

  get '/meals/:baby_id/new' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_id(params[:baby_id])
    # user may only add meal for baby that belongs to user
    if @baby
      erb :'meals/new'
    else
      redirect "/users/#{current_user.slug}?error=You may only add entries for your own babies."
    end
  end

  post '/meals/:baby_id/new' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_id(params[:baby_id])
    # user may only add meal for baby that belongs to user
    if @baby
      @meal = @baby.meals.create(params[:meal])
      # when amount is optional: if user selects amount_type without entering an amount, amount_type is set to nil
      @meal.amount_type = nil if !@meal.amount
      if @meal.save
        redirect "/meals/#{@baby.id}"
      else
        # view can access @baby and @meal in order to display validation failures with error messages
        erb :'meals/new'
      end
    else
      redirect "/users/#{current_user.slug}?error=You may only add entries for your own babies."
    end
  end

end
