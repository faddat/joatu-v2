module RepoStore
  class << self
    def repo
      RepoStore::Repo.default
    end
  end

  RecordNotFoundError = Tnt.boom do |klass, id|
    "Could not locate #{klass} with id #{id}"
  end

  QueryNotImplementedError = Tnt.boom do |selector|
    "Adapter does not support #{selector.class}!"
  end

  GraphQueryNotImplementedError = Tnt.boom do |selector|
    "Adapter does not know how to graph #{selector.class}!"
  end

  NoQueryResultError = Tnt.boom do |selector|
    "Query #{selector.class} must return results!"
  end
end
