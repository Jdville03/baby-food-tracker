class SizesController < ApplicationController

  get '/sizes/:id/edit' do
    redirect_if_not_logged_in
    @size = Size.find_by_id(params[:id])
    # user may only edit size of baby that belongs to user
    if @size && current_user.babies.include?(@size.baby)
      erb :'sizes/edit'
    else
      redirect "/users/#{current_user.slug}?error=You may only edit entries for your own babies."
    end
  end

  patch '/sizes/:id/edit' do
    redirect_if_not_logged_in
    @size = Size.find_by_id(params[:id])
    # user may only edit size of baby that belongs to user
    if @size && current_user.babies.include?(@size.baby)
      @size.entry_date = params[:entry_date]
      @size.height = params[:height]
      @size.weight = params[:weight]
      if @size.save
        redirect "/sizes/#{@size.baby.id}"
      else
        # view can access @size in order to display validation failures with error messages
        erb :'sizes/edit'
      end
    else
      redirect "/users/#{current_user.slug}?error=You may only edit entries for your own babies."
    end
  end

  delete '/sizes/:id/delete' do
    redirect_if_not_logged_in
    size = Size.find_by_id(params[:id])
    # user may only delete size of baby that belongs to user
    if size && current_user.babies.include?(size.baby)
      size.delete
      redirect "/sizes/#{size.baby.id}"
    else
      redirect "/users/#{current_user.slug}?error=You may only delete entries for your own babies."
    end
  end

  get '/sizes/:baby_id' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_id(params[:baby_id])
    # user may only view sizes for baby that belongs to user
    if @baby
      erb :'sizes/index'
    else
      redirect "/users/#{current_user.slug}?error=You may only view entries for your own babies."
    end
  end

  get '/sizes/:baby_id/new' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_id(params[:baby_id])
    # user may only add size of baby that belongs to user
    if @baby
      erb :'sizes/new'
    else
      redirect "/users/#{current_user.slug}?error=You may only add entries for your own babies."
    end
  end

  post '/sizes/:baby_id/new' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_id(params[:baby_id])
    # user may only add size of baby that belongs to user
    if @baby
      @size = @baby.sizes.create(params[:size])
      if @size.save
        redirect "/sizes/#{@baby.id}"
      else
        # view can access @baby and @size in order to display validation failures with error messages
        erb :'sizes/new'
      end
    else
      redirect "/users/#{current_user.slug}?error=You may only add entries for your own babies."
    end
  end

end
