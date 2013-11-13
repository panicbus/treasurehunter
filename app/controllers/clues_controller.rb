class CluesController < ApplicationController
  def new

  end

  def create
    @clue = Clue.create(params[:clueby])
    render json: @clue
  end

  def destroy
    Clue.delete(params[:id])
    redirect_to clues_path
  end
end
