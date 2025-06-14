# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [ Types::NodeType, null: true ], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ ID ], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    field :user, resolver: Resolvers::UserResolver
    field :users, [ Types::UserType ], null: false, description: "Returns a list of users" do
      argument :role, String, required: false, description: "Filter users by role"
      argument :limit, Integer, required: false, default_value: 10, description: "Limit the number of users returned"
      argument :offset, Integer, required: false, default_value: 0, description: "Offset for pagination"
    end
    field :tasks, resolver: Resolvers::TasksResolver
    field :task, Types::TaskType, null: true, description: "Fetch a task by ID" do
      argument :user_id, ID, required: false, description: "Filter task by user ID"
      argument :status, String, required: false, description: "Filter task by status"
      argument :limit, Integer, required: false, default_value: 10, description: "Limit the number of tasks returned"
      argument :offset, Integer, required: false, default_value: 0, description: "Offset for pagination"
    end

    def users(role: nil)
      users = User.all
      users = users.where(role: role) if role.present?
      users
    end

    def user(id:)
      user = User.find_by(id: id)
      if user.nil?
        raise GraphQL::ExecutionError, "User with ID #{id} not found"
      end
      user
    end

    def task(id:)
      task = Task.find_by(id: id)
      if task.nil?
        raise GraphQL::ExecutionError, "Task with ID #{id} not found"
      end
      task
    end
  end
end
