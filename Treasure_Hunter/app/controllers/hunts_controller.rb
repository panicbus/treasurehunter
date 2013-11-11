class HuntsController < ApplicationController

def index
  @hunts = Hunt.all

  respond_to do |format|
    format.html
    format.json { render json: @hunts }
  end
end

def show
  @hunt = Hunt.find(params[:id])

  render json: @hunt
end

def create
  Hunt.create(params[:hunt])
  redirect_to hunts_path
end

def destroy
  Hunt.destroy(params[:id])
  redirect_to hunts_path

end

end
