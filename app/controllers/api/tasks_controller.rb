class Api::TasksController < ApplicationController
  before_action :set_task, only: [ :show, :update, :destroy ]
  before_action :set_user, only: [ :create, :index ], if: -> { params[:user_id].present? }
  def index
    @tasks = @user&.tasks || Task.all
  end

  def show
    @task = Task.find_by(id: params[:id])

    if @task
      render :show
    else
      render json: { error: "Task not found" }, status: :not_found
    end
  end

  def create
    @task = Task.new(task_params)
    @task.user = @user

    if @task.save
      render :show, status: :created
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render :show, status: :ok
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
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

  def set_task
    @task = Task.find(params[:id])
    if @task.nil?
      render json: { error: "Task not found" }, status: :not_found
    end
  end

  def set_user
    @user = User.find(params[:user_id])
    if @user.nil?
      render json: { error: "User not found" }, status: :not_found
    end
  end
end
