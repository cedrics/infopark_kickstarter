module Cms
  module Generators
    module Example
      include BasePaths
      include BaseAttributes

      def self.included(base)
        base.class_option :example,
          type: :boolean,
          default: false,
          desc: 'Create an example'

        base.class_option :cms_path,
          type: :string,
          desc: 'CMS parent path where the example should be placed under'

        base.class_option :attribute,
          type: :string,
          desc: 'Widget attribute of the object class that holds the widget'
      end

      private

      def example?
        options[:example]
      end

      def example_cms_path
        options[:cms_path] || homepage_path
      end

      def example_cms_path?
        example_cms_path
      end

      def example_widget_attribute
        options[:attribute] || homepage_widget_attribute
      end

      def example_widget_attribute?
        example_widget_attribute
      end

      def example_migration_template(migration_name)
        if example?
          path = "#{widget_path_for(migration_name)}/migrate"

          migration_template(
            'example_migration.rb',
            "#{path}/create_#{migration_name}_example.rb"
          )
        end
      end
    end
  end
end