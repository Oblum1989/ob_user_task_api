module Loaders
  class AssociationLoader < GraphQL::Batch::Loader
    def self.validate(model, association_name)
      new(model, association_name)
      nil
    end

    def initialize(model, association_name)
      @model = model
      @association_name = association_name
      validate
    end

    def load(record)
      raise TypeError, "#{@model} loader can't load association for #{record.class}" unless record.is_a?(@model)
      return Promise.resolve(read_association(record)) if association_loaded?(record)
      super(record)
    end

    def cache_key(record)
      record.object_id
    end

    def perform(records)
      preload_association(records)
      records.each { |record| fulfill(record, read_association(record)) }
    end

    private

    def validate
      unless @model.reflect_on_association(@association_name)
        raise ArgumentError, "No association #{@association_name} on #{@model}"
      end
    end

    def preload_association(records)
      ::ActiveRecord::Associations::Preloader.new(records: records, associations: @association_name).call
    end

    def read_association(record)
      record.public_send(@association_name)
    end

    def association_loaded?(record)
      record.association(@association_name).loaded?
    end
  end
end
