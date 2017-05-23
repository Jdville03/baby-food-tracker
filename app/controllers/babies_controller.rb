class BabiesController < ApplicationController

  # GET: /babies
  get "/babies" do
    erb :"/babies/index"
  end

  # GET: /babies/new
  get "/babies/new" do
    erb :"/babies/new"
  end

  # POST: /babies
  post "/babies" do
    redirect "/babies"
  end

  # GET: /babies/5
  get "/babies/:id" do
    erb :"/babies/show"
  end

  # GET: /babies/5/edit
  get "/babies/:id/edit" do
    erb :"/babies/edit"
  end

  # PATCH: /babies/5
  patch "/babies/:id" do
    redirect "/babies/:id"
  end

  # DELETE: /babies/5/delete
  delete "/babies/:id/delete" do
    redirect "/babies"
  end
end
