class HuntsController < ApplicationController

def index
  @hunts = Hunt.all
end

def create
  Hunt.create(params[:hunt])
  # redirect_to hunts_path
end

def destroy
  Hunt.destroy(params[:id])
  redirect_to hunts_path
end

end
