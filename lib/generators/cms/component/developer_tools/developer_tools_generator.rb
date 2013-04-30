module Cms
  module Generators
    module Component
      class DeveloperToolsGenerator < ::Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        def install_gems
          gem_group(:test, :development) do
            gem('pry-rails')
            gem('better_errors')
            gem('binding_of_caller')
            gem('thin')
          end

          Bundler.with_clean_env do
            run('bundle --quiet')
          end
        end
      end
    end
  end
end