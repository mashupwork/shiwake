class TeamsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @team = client.team(params[:id])
    @tasks = client.team_tasks(@team['id'], state = 'uncategorized')
  end
end
