class CluesController < ApplicationController
  def new

  end

  def create
    Clue.create(params[:clue])
    redirect_to clues_path
  end

  def destroy
    Clue.delete(params[:id])
    redirect_to clues_path
  end
end
