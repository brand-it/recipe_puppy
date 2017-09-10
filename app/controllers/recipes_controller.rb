class RecipesController < ApplicationController
  before_action :set_recipes
  def index
    respond_to do |format|
      format.html
      format.js { render layout: false }
    end
  end

  private

  def set_recipes
    if params[:recipe] && params[:recipe][:query]
      @recipes = RecipePuppyClient::Search.where(query: params[:recipe][:query], page: params[:recipe][:page]).recipes
    else
      @recipes = []
    end
  end
end
