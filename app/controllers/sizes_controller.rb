class SizesController < ApplicationController

  get '/sizes/new' do

  end

  get '/sizes/:id/edit' do
    redirect_if_not_logged_in
    if @size = Size.find_by_id(params[:id])
      erb :'sizes/edit'
    else
      redirect "/users/#{current_user.slug}?error=You may only add or edit entries for your own babies."
    end
  end

  patch '/sizes/:id' do
    redirect_if_not_logged_in
    @size = Size.find_by_id(params[:id])
    if @size && current_user.babies.include?(@size.baby)
      @size.entry_date = params[:size][:entry_date]
      @size.height = params[:size][:height]
      @size.weight = params[:size][:weight]
      if @size.save
        redirect "/babies/#{@size.baby.slug}"
      else
        erb :'sizes/edit'
      end
    else
      redirect "/users/#{current_user.slug}?error=You may only add or edit entries for your own babies."
    end
  end



end
