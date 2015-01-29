class ProfileRepo < BaseRepo
  class << self
    def find_with_offers(id, offers_page = 1)
      profile = query ProfileWithOffersById.new(id, page)
      raise UnknownIdError unless profile
      profile
    end

    def all_for_user(user, page = 1)
      query AllProfilesForUser.new(user, page)
    end
  end

  AllProfilesForUser = Struct.new(:user, :page)
  ProfileWithOffersById = Struct.new(:id, :offers_page)
end

