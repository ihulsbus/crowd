# Chef class
class Chef
  # Chef::Recipe class
  class Recipe
    # Chef::Recipe::Crowd class
    class Crowd
      def self.settings(node)
        begin
          if Chef::Config[:solo]
            begin
              settings = Chef::DataBagItem.load('crowd', 'crowd')['local']
            rescue
              Chef::Log.info('No crowd data bag found')
            end
          else
            begin
              settings = Chef::EncryptedDataBagItem.load('crowd', 'crowd')[node.chef_environment]
            rescue
              Chef::Log.info('No crowd encrypted data bag found')
            end
          end
        ensure
          settings ||= node['crowd']

          case settings['database']['type']
          when 'mysql'
            settings['database']['port'] ||= 3306
          when 'postgresql'
            settings['database']['port'] ||= 5432
          else
            Chef::Log.warn('Unsupported database type.')
          end
        end

        settings
      end
    end
  end
end
