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

        storext_overrider_define_override_control(column_name, attr)
        storext_overrider_define_reader(association_name, column_name, attr)
        storext_overrider_define_writer(column_name, attr)
      end

      def storext_overrider_define_reader(association_name, column_name, attr)
        define_method :"#{attr}_with_parent_default" do |*args|
          if send(column_name).has_key?(attr)
            send(:"#{attr}_without_parent_default", *args)
          else
            send(association_name).send(attr)
          end
        end
        alias_method_chain :"#{attr}", :parent_default
      end

      def storext_overrider_define_writer(column_name, attr)
        define_method :"#{attr}_with_override_control=" do |*args|
          if send(:"override_#{attr}") == false
            destroy_key(column_name, attr)
          else
            send(:"#{attr}_without_override_control=", *args)
          end
        end
        alias_method_chain :"#{attr}=", :override_control
      end

      def storext_overrider_define_override_control(column_name, attr)
        ivar = "@override_#{attr}"

        define_method :"override_#{attr}=" do |bool|
          destroy_key(column_name, attr) if bool == false
          instance_variable_set(ivar, bool)
        end

        define_method :"override_#{attr}" do
          instance_variable_get(ivar)
        end
      end
    end

  end
end

# rest of our requires here...
