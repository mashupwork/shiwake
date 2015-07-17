json.array! @tasks do |task|
  json.id task['id']
  json.label task['path']
end

