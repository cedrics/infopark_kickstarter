module Cms
  module Generators
    module Component
      class SearchPageGenerator < ::Rails::Generators::Base
        include Migration
        include BasePaths
        include Actions

        class_option :homepage_path,
          :type => :string,
          :default => nil,
          :desc => 'Path to a CMS homepage, for which to create the contact form.'

        source_root File.expand_path('../templates', __FILE__)

        def extend_homepage
          file = 'app/models/homepage.rb'
          insert_point = "class Homepage < Obj\n"

          data = []

          data << '  include Cms::Attributes::SearchPageLink'
          data << ''

          data = data.join("\n")

          insert_into_file(file, data, :after => insert_point)
        end

        def extend_view
          file = 'app/views/layouts/application.html.haml'
          insert_point = '            = render_cell(:meta_navigation, :show, @obj, current_user)'

          data = []

          data << "\n"
          data << '            .well'
          data << '              %h3'
          data << "                = t('search.title')"
          data << ''
          data << '              = render_cell(:search, :show, @obj)'

          data = data.join("\n")

          insert_into_file(file, data, :after => insert_point)
        end

        def create_migration
          begin
            validate_attribute(search_page_attribute_name)

            Rails::Generators.invoke('cms:attribute', [search_page_attribute_name, '--type=linklist', '--title=Search Page', '--max-size=1'])
          rescue Cms::Generators::DuplicateResourceError
          end

          begin
            validate_attribute(show_in_navigation_attribute_name)

            Rails::Generators.invoke('cms:attribute', [show_in_navigation_attribute_name, '--type=boolean', '--title=Show in Navigation'])
          rescue Cms::Generators::DuplicateResourceError
          end

          begin
            validate_obj_class(class_name)

            Rails::Generators.invoke('cms:scaffold', [class_name, '--title=Page: Search', '--attributes=show_in_navigation'])

            turn_model_into_page(class_name)
          rescue Cms::Generators::DuplicateResourceError
          end

          migration_template('example_migration.rb', 'cms/migrate/create_search_page_example.rb')
        end

        def copy_app_directory
          directory('app', force: true)
          directory('config', force: true)
          directory('spec', force: true)
        end

        def notice
          if behavior == :invoke
            log(:migration, 'Make sure to run "rake cms:migrate" to apply CMS changes and "bundle" to install new gem.')
          end
        end

        private

        alias_method :original_homepage_path, :homepage_path
        def homepage_path
          options[:homepage_path] || original_homepage_path
        end

        def show_in_navigation_attribute_name
          'show_in_navigation'
        end

        def search_page_attribute_name
          'search_page_link'
        end

        def class_name
          'SearchPage'
        end
      end
    end
  end
end