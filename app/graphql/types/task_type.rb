module Types
  class TaskType < Types::BaseObject
    description "A task that can be assigned to a user"

    field :id, ID, null: false, description: "The unique identifier of the task"
    field :title, String, null: false, description: "The title of the task"
    field :description, String, null: true, description: "The description of the task"
    field :status, String, null: false, description: "The current status of the task (pending, completed, expired, archived)"
    field :due_date, GraphQL::Types::ISO8601Date, null: false, description: "The due date of the task"
    field :user, Types::UserType, null: false, description: "The user this task is assigned to"
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: "The date and time when the task was created"
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false, description: "The date and time when the task was last updated"

    def user
      Loaders::AssociationLoader.for(Task, :user).load(object)
    end
  end
end
