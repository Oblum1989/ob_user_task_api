class Api::AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :login, :register ]
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      render json: {
        message: "Login successful",
        token: user.auth_token,
        user: { id: user.id, full_name: user.full_name, email: user.email }
      }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def logout
    user = User.find_by(auth_token: params[:token])
    if user
      user.update(auth_token: " ")
      render json: { message: "Logout successful" }, status: :ok
    else
      render json: { error: "Invalid token" }, status: :unauthorized
    end
  end

  def register
    user = User.new(user_params)
    if user.save
      render json: {
        message: "Registration successful",
        user: { id: user.id, full_name: user.full_name, email: user.email }
      }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :full_name, :role)
  end
end
