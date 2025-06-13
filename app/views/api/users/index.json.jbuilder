json.array! @users do |user|
  json.id user.id
  json.name user.full_name
  json.email user.email
  json.role user.role
  json.tasks user.tasks.map { |task|
    {
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      due_date: task.due_date
    }
  }
end
