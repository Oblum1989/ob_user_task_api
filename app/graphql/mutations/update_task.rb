class Mutations::UpdateTask < Mutations::BaseMutation
  argument :id, ID, required: true
  argument :title, String, required: false
  argument :description, String, required: false
  argument :status, String, required: false
  argument :due_date, GraphQL::Types::ISO8601Date, required: false

  type Types::TaskType

  def resolve(id:, title: nil, description: nil, status: nil, due_date: nil)
    task = Task.find(id)

    task.update!(
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
