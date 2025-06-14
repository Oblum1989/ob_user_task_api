module Resolvers
  class TasksResolver < Resolvers::BaseResolver
    description "Returns tasks based on specified filters"

    type [ Types::TaskType ], null: false

    argument :user_id, ID, required: false, description: "Filter tasks by user ID"
    argument :status, String, required: false, description: "Filter tasks by status"

    def resolve(user_id: nil, status: nil)
      tasks = Task.all

      tasks = tasks.where(user_id: user_id) if user_id.present?
      tasks = tasks.where(status: status) if status.present?

      tasks
    rescue ActiveRecord::RecordNotFound => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end
