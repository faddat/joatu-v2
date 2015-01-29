class User < DomainModel
  attribute :name
  attribute :email

  attribute :profile, DomainModel.attr_type(:Profile)
  attribute :mailbox, DomainModel.attr_type(:Mailbox)

  attribute :offers, DomainCollection[:Offer]
  attribute :communities, DomainCollection[:Community]

  # delegate :is_admin?, to: :model
end
