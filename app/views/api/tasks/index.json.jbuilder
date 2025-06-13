json.array! @tasks do |task|
  json.id task.id
  json.title task.title
  json.description task.description
  json.status task.status
  json.due_date task.due_date
end
