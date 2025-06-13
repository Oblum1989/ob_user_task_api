class Api::TasksController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @tasks = @user.tasks
  end

  def show
    @user = User.find(params[:user_id])
    @task = @user.tasks.find(params[:id])
  end

  def create
    @user = User.find(params[:user_id])
    @task = @user.tasks.new(task_params)

    if @task.save
      render :show, status: :created
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:user_id])
    @task = @user.tasks.find(params[:id])

    if @task.update(task_params)
      render :show, status: :ok
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @task = @user.tasks.find(params[:id])

    if @task.destroy
      head :no_content
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end
  def user_params
    params.require(:user).permit(:email, :full_name, :role)
  end
end
