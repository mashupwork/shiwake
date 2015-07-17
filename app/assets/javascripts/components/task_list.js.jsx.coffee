@TaskList = React.createClass
  propTypes:
    initialTasks: React.PropTypes.array.isRequired
    teamId: React.PropTypes.number.isRequired

  getInitialState: ->
    tasks: @props.initialTasks
    parents: []
    loading: false

  handleSaveItem: ->
    @fetchParents()

  componentWillMount: ->
    @fetchParents()

  fetchParents: ->
    @setState(loading: true)
    $.ajax
      method: 'GET'
      dataType: 'json'
      url: "/teams/#{@props.teamId}/tasks"
      success: (data) =>
        @setState(parents: data)
      error: (jqXHR, textStatus, errorThrown) ->
        console.error(jqXHR, textStatus, errorThrown)
        alert("#{textStatus}\n#{errorThrown}")
        @setState(editing: false)
      complete: =>
        @setState(loading: false)

  render: ->
    unless @state.parents.length
      return `<div><i className="fa fa-fw fa-spinner fa-pulse fa-lg"></i></div>`

    spinner = if @state.loading
                `<small>&nbsp;<i className="fa fa-fw fa-spinner fa-pulse text-muted"></i></small>`
              else
                `<span></span>`

    itemNodes = @state.tasks.map (task) =>
      props =
        task: task
        onSave: @handleSaveItem
        parents: @state.parents
        teamId: @props.teamId
      `<TaskItem {...props} key={task.id} />`

    `<div>
      <h3>
        Uncategorized tasks
        {spinner}
      </h3>
      <table className="table table-hover">
        {itemNodes}
      </table>
    </div>`

