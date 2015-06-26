require 'storext'

module Storext
  module Override

    extend ActiveSupport::Concern

    included do
      include Storext.model
    end

    module ClassMethods
      def storext_override(association_name, column_name)
        association =
          storext_overrider_find_association(association_name)
        association_class = association.class_name.constantize

        storext_definitions = association_class.storext_definitions
        storext_definitions.each do |attr, attr_definition|
          if attr_definition[:column] == column_name
            storext_overrider_accessor(
              association_name,
              column_name,
              attr,
              attr_definition
            )
          end
        end
      end

      private

      def storext_overrider_find_association(name)
        self.reflect_on_all_associations.find do |a|
          a.name == name
        end
      end

      def storext_overrider_accessor(association_name, column_name, attr, attr_definition)
        self.store_attribute(
          column_name,
          attr,
          attr_definition[:type],
          attr_definition[:opts].reject { |k,v| k == :default },
        )

        storext_overrider_define_reader(association_name, column_name, attr)
      end

      def storext_overrider_define_reader(association_name, column_name, attr)
        define_method attr do |*args|
          if send(column_name).has_key?(attr)
            super(*args)
          else
            send(association_name).send(attr)
          end
        end
      end
    end

  end
end

# rest of our requires here...
