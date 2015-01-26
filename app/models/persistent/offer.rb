class Persistent::Offer < Persistent::Base
  belongs_to :user

  def self.owned_by(user)
    where(user_id: user.id)
  end
end