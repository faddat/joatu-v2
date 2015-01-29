class Community < DomainModel
  attribute :name
  attribute :members, DomainCollection[:User]
end
