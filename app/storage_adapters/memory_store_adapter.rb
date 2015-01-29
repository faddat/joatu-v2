class MemoryStoreAdapter < RepoStore::Adapters::MemoryAdapter
  def query_all_offers_with_creator_for_user(klass, q)
    DomainCollection.new(
      all(klass),
      {
        limit: q.per,
        offset: (q.page - 1) * q.per,
        total: count
      }
    )
  end
end
