@TaskItem = React.createClass
  propTypes:
    task: React.PropTypes.object.isRequired
    parents: React.PropTypes.array.isRequired
    onSave: React.PropTypes.func.isRequired
    teamId: React.PropTypes.number.isRequired

  getInitialState: ->
    editing: false
    removed: false
    loading: false
    selected: ''

  componentWillUpdate: ->
    parent = React.findDOMNode(@refs.parent)
    return unless parent
    $(parent).remove()

  componentDidUpdate: ->
    parent = React.findDOMNode(@refs.parent)
    return unless parent
    $(parent).select2()

  shouldComponentUpdate: (nextProps, nextState) ->
    if !@state.loading && !nextState.loading && @state.editing && nextState.editing
      false
    else
      true

  handleTitleClick: (e) ->
    e.preventDefault()
    @setState(editing: true)

  handleSaveClick: (e) ->
    e.preventDefault()

    parent = React.findDOMNode(@refs.parent)
    return unless parent

    parentId = parseInt($(parent).select2('val'))
    return unless parentId

    for parent in @props.parents
      if parent.id == parentId
        @setState(selected: parent.label)
        break

    params =
      _method: 'PATCH'
      parent_id: parentId
    console.log params

    @setState(loading: true)

    $.ajax
      method: 'POST'
      dataType: 'json'
      url: "/teams/#{@props.teamId}/tasks/#{@props.task.id}"
      data: params
      success: =>
        @setState(removed: true)
        @props.onSave()
      error: (jqXHR, textStatus, errorThrown) ->
        console.error(jqXHR, textStatus, errorThrown)
        errors = jqXHR.responseJSON
        alert(errors.join('\n'))
      complete: =>
        @setState(editing: false, loading: false)

  handleCancelClick: (e) ->
    e.preventDefault()
    @setState(editing: false)

  render: ->
    titleNode = if @state.editing
                  `<strong>{this.props.task.title}</strong>`
                else
                  `<a href="#" onClick={this.handleTitleClick}>{this.props.task.title}</a>`
    taskNode = `<td className="text-break">
                 {titleNode}
                 &nbsp;
                 <a href={this.props.task.html_url} target="_blank">
                   <i className="fa fa-fw fa-external-link"></i>
                 </a>
                 <br />
                 <span className="text-muted">{this.props.task.url}</span>
               </td>`

    parentsNode = @props.parents.map (parent) =>
      if parent.id != @props.task.id
        `<option value={parent.id} key={parent.id}>{parent.label}</option>`

    hidden = if @state.removed then 'hidden' else ''

    if @state.loading
      `<tr className={hidden}>
        {taskNode}
        <td>
          <span className="label label-default text-break">{this.state.selected}</span>
        </td>
        <td>
          <td className="text-nowrap">
            <i className="fa fa-fw fa-spinner fa-pulse fa-lg"></i>
          </td>
        </td>
      </tr>`
    else if @state.editing
      `<tr className={hidden}>
        {taskNode}
        <td>
          <select className="select-parent" ref="parent">
            <option></option>
            {parentsNode}
          </select>
        </td>
        <td className="text-nowrap">
          <button className="btn btn-primary btn-sm" onClick={this.handleSaveClick}>
            <i className="fa fa-fw fa-check"></i>
          </button>
          <button className="btn btn-default btn-sm" onClick={this.handleCancelClick}>
            <i className="fa fa-fw fa-remove"></i>
          </button>
        </td>
      </tr>`
    else
      `<tr className={hidden}>
        {taskNode}
        <td></td>
        <td></td>
      </tr>`

