class ActiveRecordAdapter < RepoStore::Adapters::BaseAdapter
  AR_CLASS_MAP = {
    :User => :'Persistent::User'
  }

  def create(record)
    ar_model = ar_class(record).create(record.deep_hash)
    record.id = ar_model.id
  end

  def update(record)
    ar_class(record).where(id: record.id).update(record.deep_hash)
  end

  def delete(record)
    ar_class(record).destroy(record.id)
  end

  def clear
    raise NotSupported :sample
  end

  def all(klass)
    ar_class(klass).all
  end

  def find(klass, id)
    ar_class(klass).find(id)
  end

  def first(klass)
    ar_class(klass).first
  end

  def last(klass)
    ar_class(klass).last
  end

  def sample(klass)
    raise NotSupported :sample
  end

  def empty?(klass)
    !ar_class(klass).any?
  end

  def count(klass)
    ar_class(klass).count
  end

  def initialize_storage
  end

  def query_all_offers_with_creator_for_user(klass, q)
    ar_offers = ar_klass(klass).includes(user: [:profile]).page(q.page)
    offers = ar_offers.map {|o| Offer.new(o.to_h) }
    DomainCollection.new(
      offers,
      {
        limit: q.per,
        offset: (q.page - 1) * q.per,
        total: count
      }
    )
  end

  private
  def ar_class(record)
    if record.respond_to? :< && record < DomainModel 
      key = record.name.to_sym
    else
      key = record.class.name.to_sym
    end

    raise NoMappedARModel.new record unless AR_CLASS_MAP.key?(key)
    AR_CLASS_MAP[key].to_s.constantize
  end

  NoMappedARModel = Tnt.boom do |record|
    raise "No ActiveRecord model found to serve as a backend for #{record}"
  end

  NotSupported = Tnt.boom do |method|
    "#{method} not supported by #{self.class.name}"
  end
end
