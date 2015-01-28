class ProfileRepo
  extend RepoStore::Delegation

  class << self
    def find_by_id(id)
      profile = query ProfileWithId.new(id)
      raise "Unknwon id error" unless profile
      profile
    end
  end
end

ProfileWithId = Struct.new(:id)
