class Profile < Base
  belongs_to :user

  def self.available_to(user)
    self
  end

  def full_name
    name = "#{given_name} #{surname}".strip
    name.blank? ? "anonymous" : name
  end
end
