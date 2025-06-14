module Types
  class UserType < Types::BaseObject
    description "A user from the application"

    field :id, ID, null: false, description: "The unique identifier of the user"
    field :email, String, null: false, description: "The email address of the user"
    field :full_name, String, null: true, description: "The name of the user"
    field :role, String, null: false, description: "The role of the user in the application"
    field :tasks, [ Types::TaskType ], null: false, description: "Tasks assigned to the user"
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: "The date and time when the user was created"

    def tasks
      Loaders::AssociationLoader.for(User, :tasks).load(object)
    end
  end
end
