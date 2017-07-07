class SizesController < ApplicationController

  get '/sizes/:id/edit' do
    redirect_if_not_logged_in
    @size = Size.find_by_id(params[:id])
    if @size && current_user.babies.include?(@size.baby)
      erb :'sizes/edit'
    else
      redirect "/users/#{current_user.slug}?error=You may only edit entries for your own babies."
    end
  end

  patch '/sizes/:id/edit' do
    redirect_if_not_logged_in
    @size = Size.find_by_id(params[:id])
    if @size && current_user.babies.include?(@size.baby)
      @size.entry_date = params[:entry_date]
      @size.height = params[:height]
      @size.weight = params[:weight]
      if @size.save
        redirect "/sizes/#{@size.baby.id}"
      else
        erb :'sizes/edit'
      end
    else
      redirect "/users/#{current_user.slug}?error=You may only edit entries for your own babies."
    end
  end

  delete '/sizes/:id/delete' do
    redirect_if_not_logged_in
    size = Size.find_by_id(params[:id])
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
    if @baby
      erb :'sizes/index'
    else
      redirect "/users/#{current_user.slug}?error=You may only view entries for your own babies."
    end
  end

  get '/sizes/:baby_id/new' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_id(params[:baby_id])
    if @baby
      erb :'sizes/new'
    else
      redirect "/users/#{current_user.slug}?error=You may only add entries for your own babies."
    end
  end

  post '/sizes/:baby_id/new' do
    redirect_if_not_logged_in
    @baby = current_user.babies.find_by_id(params[:baby_id])
    if @baby
      @size = @baby.sizes.create(params[:size])
      if @size.save
        redirect "/sizes/#{@baby.id}"
      else
        erb :'sizes/new'
      end
    else
      redirect "/users/#{current_user.slug}?error=You may only add entries for your own babies."
    end
  end

end
