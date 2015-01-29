class CommunityRepo < BaseRepo
  class << self
    def all_for_user(user, page = 1)
      query AllCommunitiesForUser.new(user, page)
    end
  end

  AllCommunitiesForUser = Struct.new(:user, :page)
end
