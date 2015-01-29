class OfferRepo < BaseRepo
  class << self
    def all_with_creator_for_user(user, page = 1)
      query AllOffersWithCreatorForUser.new(user, page)
    end

    def search_by_string(string, user, page = 1)
      query SearchOffersByString.new(string, user, page)
    end
  end
end
AllOffersWithCreatorForUser = Struct.new(:user, :page)
SearchOffersByString = Struct.new(:string, :user, :page)

