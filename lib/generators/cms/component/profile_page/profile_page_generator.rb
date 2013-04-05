module Cms
  module Generators
    module Component
      class ProfilePageGenerator < ::Rails::Generators::Base
        include Migration
        include BasePaths
        include Actions

        class_option :homepage_path,
          :type => :string,
          :default => nil,
          :desc => 'Path to a CMS homepage, for which to create the contact form.'

        class_option :skip_translation_import,
          :type => :boolean,
          :default => false,
          :desc => 'Skip import of country translation files.'

        source_root File.expand_path('../templates', __FILE__)

        def add_gems
          gem('valid_email', '0.0.4')
          gem('localized_country_select', '>= 0.9.2')

          Bundler.with_clean_env do
            run('bundle --quiet')
          end
        end

        def import_translations
          unless options[:skip_translation_import]
            run('rake import:country_select LOCALE=en')
            run('rake import:country_select LOCALE=de')
          end
        end

        def extend_homepage
          file = 'app/models/homepage.rb'
          insert_point = "class Homepage < Obj\n"

          data = []

          data << '  include Cms::Attributes::ProfilePageLink'
          data << ''

          data = data.join("\n")

          insert_into_file(file, data, :after => insert_point)
        end

        def extend_cell
          file = 'app/cells/meta_navigation_cell.rb'
          insert_point = "@current_user = current_user\n"

          data = []

          data << ''
          data << '    @profile_page = page.homepage.profile_page'
          data << ''

          data = data.join("\n")

          insert_into_file(file, data, :after => insert_point)
        end

        def extend_view
          file = 'app/cells/meta_navigation/show.html.haml'
          insert_point = "      = t('.meta')\n"

          data = []

          data << '    - if @current_user.logged_in?'
          data << '      %li'
          data << '        = link_to(cms_path(@profile_page)) do'
          data << '          = display_title(@profile_page)'
          data << ''

          data = data.join("\n")

          insert_into_file(file, data, :after => insert_point)
        end

        def create_migration
          begin
            Model::ApiGenerator.new(behavior: behavior) do |model|
              model.name = class_name
              model.title = 'Page: Profile'
              model.attributes = [
                {
                  name: show_in_navigation_attribute_name,
                  type: :boolean,
                  title: 'Show in navigation',
                },
              ]
            end

            turn_model_into_page(class_name)
          rescue Cms::Generators::DuplicateResourceError
          end

          migration_template('example_migration.rb', 'cms/migrate/create_profile_page_example.rb')
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

        def profile_page_attribute_name
          'profile_page_link'
        end

        def class_name
          'ProfilePage'
        end
      end
    end
  end
end