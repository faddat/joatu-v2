module AttrType
  extend ActiveSupport::Concern

  CoercionError = Tnt.boom do |value, type|
    "#{value} is not an instance of #{type}"
  end

  module ClassMethods
    # Generates and returns an Virtus::Attribute object to coerce objects
    # into instances of type_class. Works for collections as well.
    def attr_type(type_class)
      @generated_attribute_classes ||= {}
      @generated_attribute_classes[type_class] ||= Class.new(Virtus::Attribute) do
        define_method :initialize do |*args|
          unless args.empty?
            super(*args)
          end
        end

        define_method :type do
          type_class.to_s.constantize
        end

        define_method :coerce do |value|
          if value.present?
            raise CoercionError.new(value, type_class) unless value.is_a? type_class.to_s.constantize
          end
          value
        end
      end
    end
  end
end
