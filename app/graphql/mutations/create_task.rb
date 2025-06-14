class Mutations::CreateTask < Mutations::BaseMutation
  argument :title, String, required: true
  argument :description, String, required: false
  argument :status, String, required: false
  argument :due_date, GraphQL::Types::ISO8601Date, required: true
  argument :user_id, ID, required: true

  type Types::TaskType

  def resolve(title:, due_date:, user_id:, description: nil, status: "pending")
    user = User.find(user_id)
    task = user.tasks.create!(
      title: title,
      description: description,
      status: status,
      due_date: due_date
    )
    task
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new(e.record.errors.full_messages.join(", "))
  end
end
