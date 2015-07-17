class TimeCrowd
  attr_accessor :client, :access_token

  def initialize(token)
    self.client = OAuth2::Client.new(
      Settings.timecrowd.client_id,
      Settings.timecrowd.client_secret,
      site: Settings.timecrowd.site,
      ssl: { verify: false }
    )
    self.access_token = OAuth2::AccessToken.new(client, token)
  end

  def teams(state = nil)
    access_token.get("/api/v1/teams?state=#{state}").parsed
  end

  def team(id)
    access_token.get("/api/v1/teams/#{id}").parsed
  end

  def team_tasks(team_id, state = nil)
    access_token.get("/api/v1/teams/#{team_id}/tasks?state=#{state}").parsed
  end

  def update_team_task(team_id, id, body)
    access_token.put("/api/v1/teams/#{team_id}/tasks/#{id}", body: body).parsed
  end
end
