class TasksController < ApplicationController
# authentication callback before action, no authentication required to the excepts ones
 # before_action :authenticate, except: [:index]

# GET /tasks
  def index
    if params[:user_id]
      @tasks = Task.where({user_id: params[:user_id]})
    else
      @tasks = Task.all
    end
  end

  def new
    @task = Task.new
    @user = User.new
  end

# GET /tasks/new
  def create
    Task.create(task_params)
    id = session[:user_id]
    task = Task.last
    t_id= task.id
    t_id = t_id
    Tasking.create({user_id: id, task_id: t_id })
    redirect_to tasks_path
  end

# GET /tasks/:id - show task
  def show
    @task = Task.find(params[:id])
  end

# GET /tasks/:id/edit
  def edit
    @task = Task.find(params[:id])
  end

# POST
  def update
    task = Task.find(params[:id])
    task.update(task_params)
    redirect_to tasks_path
  end

# DELETE /tasks/:id
  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to tasks_path
  end

  private
  def task_params
    params.require(:task).permit(:title, :content, :duedate, :location, :image)
  end

  # def tasking_params
  #   params.require(:tasking).permit(:user_id, :task_id)
  # end
end
