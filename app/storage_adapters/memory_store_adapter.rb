class MemoryStoreAdapter < RepoStore::Adapters::MemoryAdapter
  def query_profile_with_id(klass, q)
    all(klass).find do |profile|
      profile.id == q.id
    end
  end
end
