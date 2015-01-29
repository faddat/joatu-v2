class DomainModel
  include Virtus.model strict: true
  include ActiveModel::Model
  include RepoStore::Persistence
  include AttrType

  def initialize(data = {})
    unless data.is_a?(Hash) || data.nil?
      raise ArgumentError.new "Must initialize a #{self.class.name} with a hash or nil."
    end
    super
  end

  attribute :id

  def persisted?
    self.id.present?
  end

  def to_partial_path
    "#{self.class.name.pluralize}/#{self.class.name}"
  end

  def deep_hash
    hash = {}
    self.to_h.each do |k,v|
      if v.is_a? DomainModel
        v = v.deep_hash
      elsif v.is_a? DomainCollection
        v = v.map(&:deep_hash)
      end

      hash[k] = v
    end

    hash
  end
end
