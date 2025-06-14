module Resolvers
  class UserResolver < Resolvers::BaseResolver
    description 'Fetch a user by ID'

    argument :id, ID, required: true, description: 'The unique identifier of the user'
    type Types::UserType, null: true
    def resolve(id:)
      user = User.find_by(id: id)
      if user.nil?
        raise GraphQL::ExecutionError, "User with ID #{id} not found"
      end
      user
    rescue ActiveRecord::RecordNotFound => e
      raise GraphQL::ExecutionError, "User with ID #{id} not found: #{e.message}"
    rescue StandardError => e
      raise GraphQL::ExecutionError, "An error occurred while fetching the user: #{e.message}"
    end
  end
end
