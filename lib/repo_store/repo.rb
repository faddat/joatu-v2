module RepoStore
  class Repo
    include Interchange.new(*[
      :all, :find, :create, :update, :delete,
      :first, :last, :query, :graph_query,
      :sample, :empty?, :count, :clear,
      :initialize_storage
    ])

    class << self
      def default
        @default ||= new
      end
    end

    def find(klass, id)
      raise ArgumentError, "id cannot be nil!" if id.nil?
      super
    end

    def save(record)
      if record.id
        update record
      else
        create record
      end
    end

    def query!(klass, selector)
      result = query klass, selector
      no_results = result.respond_to?(:empty?) ? result.empty? : result.nil?

      if no_results && block_given?
        yield klass, selector
      elsif no_results
        fail NoQueryResultError, selector
      end

      result
    end
  end
end
