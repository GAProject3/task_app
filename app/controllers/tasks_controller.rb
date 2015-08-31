class TasksController < ApplicationController
# authentication callback before action, no authentication required to the excepts ones
 # before_action :authenticate, except: [:index]

#GET /tasks

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

     # for validation for required field if the input is not valid redirect to the create new form, 
     @task = Task.new(task_params)

     if @task.save
        Tasking.create({user_id: current_user.id, task_id: @task.id })
        current_user.id
        flash[:success] = "Task had been saved sucessfully."
        redirect_to current_user

     else
        flash[:danger] = "Task not saved. Required fields are incomlete."
        redirect_to new_task_path
     end
  end


# GET /tasks/:id - show task
  def show
    @task = Task.find(params[:id])

city = @task.location
# state = @task.location
city.gsub(" ", "%20")
# response = HTTParty.get("http://api.wunderground.com/api/4a9cdbbd8fedfdc6/conditions/q/NY/#{city}.json")

# @weather_feel = response["current_observation"]["feelslike_f"]

# @weather_condition = response["current_observation"]["weather"]   



response = HTTParty.get("https://george-vustrey-weather.p.mashape.com/api.php?location=#{city}",
  headers:{
    "X-Mashape-Key" => "Z8lHkBrDMgmshwSAaNYu49INydgsp1IxGesjsneAYhnegsAJBX",
    "Accept" => "application/json"
  })
  
  @weather_day = response[1]["day_of_week"]
  @weather_condition = response[0]["condition"]
  @weather_feel = response[2]["high"]

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
    # double confirmetion for the delete
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
