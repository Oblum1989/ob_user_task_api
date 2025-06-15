class Api::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user
      render :show
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end
end
