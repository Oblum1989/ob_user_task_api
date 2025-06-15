# frozen_string_literal: true

module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    def current_user
      context[:current_user]
    end

    # Método opcional para usar en resolvers que necesiten autenticación
    def authenticate_user!
      raise GraphQL::ExecutionError, "You need to be logged in to perform this action" unless current_user
    end

    # Por defecto no requerimos autenticación
    def authorized?(args = nil)
      true
    end
  end
end
