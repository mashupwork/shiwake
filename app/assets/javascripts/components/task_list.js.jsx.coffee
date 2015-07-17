@TaskList = React.createClass
  propTypes:
    initialTasks: React.PropTypes.array.isRequired
    teamId: React.PropTypes.number.isRequired

  getInitialState: ->
    tasks: @props.initialTasks
    parents: []

  handleSaveItem: (taskId) ->
    #index = 0
    #for task, i in @state.tasks
    #  if taskId == task.id
    #    index = i
    #    break
    #tasks = React.addons.update(@state.tasks, { $splice: [[index, 1]] })
    #@setState(tasks: tasks)

  componentWillMount: ->
    @fetchParents()

  fetchParents: ->
    $.ajax
      method: 'GET'
      dataType: 'json'
      url: "/teams/#{@props.teamId}/tasks"
      success: (data) =>
        @setState(parents: data)
      error: (jqXHR, textStatus, errorThrown) ->
        console.error(jqXHR, textStatus, errorThrown)
        errors = jqXHR.responseJSON
        alert(errors.join('\n'))
      complete: =>

  render: ->
    unless @state.parents.length
      return `<div><i className="fa fa-fw fa-spinner fa-pulse fa-lg"></i></div>`

    itemNodes = @state.tasks.map (task) =>
      props =
        task: task
        onSave: @handleSaveItem
        parents: @state.parents
        teamId: @props.teamId
      `<TaskItem {...props} key={task.id} />`

    `<table className="table table-hover">
      {itemNodes}
    </table>`

