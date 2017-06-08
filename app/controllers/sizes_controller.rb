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
        redirect "/babies/#{@size.baby.slug}"
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
    size.delete if size && current_user.babies.include?(size.baby)
    redirect "/babies/#{size.baby.slug}"
  end

  get '/sizes/:slug/new' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_slug(params[:slug])
    # user may only add size of baby that belongs to user
    if @baby
      erb :'sizes/new'
    else
      redirect "/users/#{current_user.slug}?error=You may only add entries for your own babies."
    end
  end

  post '/sizes/:slug/new' do
    redirect_if_not_logged_in
    @size = Size.create(entry_date: params[:entry_date], height: params[:height], weight: params[:weight], baby: Baby.find_by_slug(params[:slug]))
    # user may only add size of baby that belongs to user
    if @size.save && current_user.babies.include?(@size.baby)
      redirect "/babies/#{@size.baby.slug}"
    elsif @size.save && !current_user.babies.include?(@size.baby)
      redirect "/users/#{current_user.slug}?error=You may only add entries for your own babies."
    elsif !@size.save && current_user.babies.include?(@size.baby)
      # view can access @size in order to display validation failures with error messages
      @baby = @size.baby
      erb :'sizes/new'
    end
  end

end
