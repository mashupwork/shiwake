class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = client.team_tasks(params[:team_id]).sort { |a, b| a['path'] <=> b['path'] }
    render formats: :json
  end

  def update
    client.update_team_task(params[:team_id], params[:id], { parent_id: params[:parent_id] })
    render json: {}
  end
end
