@TaskFilter = React.createClass
  propTypes:
    tasks: React.PropTypes.array.isRequired
    handleFilter: React.PropTypes.array.isRequired

  handleChange: (e) ->
    tasks = @filterTasks(e.target.value)
    @props.handleFilter(tasks)

  filterTasks: (filterText) ->
    filterText = filterText.toLowerCase();
    if !filterText
      @props.tasks
    else
      @props.tasks.filter (task) =>
        task.title.toLowerCase().indexOf(filterText) != -1 ||
        task.url.toLowerCase().indexOf(filterText) != -1

  render: ->
    `<div>
      <h3>
        Filter
      </h3>
      <input
        type="text"
        ref="parenta"
        placeholder="keyword"
        onChange={this.handleChange}
      />
    </div>
    `
