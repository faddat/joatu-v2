class Profile
  include RepoStore::Persistence
  include Virtus.model

  # association :user, :User
  attribute :given_name
  attribute :surname
  attribute :about_me
end
