# Crowd module
module Crowd
  # Crowd::Helpers module
  module Helpers

    def crowd_database_connection
      settings = merge_crowd_settings

      database_connection = {
        host: settings['database']['host'],
        port: settings['database']['port'],
      }

      case settings['database']['type']
      when 'mysql'
        database_connection[:username] = 'root'
        database_connection[:password] = node['mysql']['server_root_password']
      when 'postgresql'
        database_connection[:username] = 'postgres'
        database_connection[:password] = node['postgresql']['password']['postgres']
      end

      database_connection
    end

    # Merges Crowd settings from data bag and node attributes.
    # Data dag settings always has a higher priority.
    #
    # @return [Hash] Settings hash
    def merge_crowd_settings
      @settings_from_data_bag ||= settings_from_data_bag
      settings = Chef::Mixin::DeepMerge.deep_merge(
        @settings_from_data_bag,
        node['crowd'].to_hash
      )

      case settings['database']['type']
      when 'mysql'
        settings['database']['port'] ||= 3306
      when 'postgresql'
        settings['database']['port'] ||= 5432
      when 'hsqldb'
        # No-op. HSQLDB doesn't require any configuration.
        Chef::Log.warn('HSQLDB should not be used in production.')
      else
        raise "Unsupported database type: #{settings['database']['type']}"
      end

      settings
    end

    # Fetchs Crowd settings from the data bag
    #
    # @return [Hash] Settings hash
    def settings_from_data_bag
      begin
        item = data_bag_item(node['crowd']['data_bag_name'],
                             node['crowd']['data_bag_item'])['crowd']
        return item if item.is_a?(Hash)
      rescue
        Chef::Log.info('No crowd data bag found')
      end
      {}
    end

    # Returns download URL for Crowd artifact
    def crowd_artifact_url
      return node['crowd']['url'] unless node['crowd']['url'].nil?

      base_url = 'http://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd'
      version  = node['crowd']['version']

      # Return actual URL
      case node['crowd']['install_type']
      when 'installer'
        Chef::Log.fail('Atlassian Crowd currently does not have an installer.')
      when 'standalone'
        "#{base_url}-#{version}.tar.gz"
      end
    end

    # Returns SHA256 checksum of specific Crowd artifact
    def crowd_artifact_checksum
      return node['crowd']['checksum'] unless node['crowd']['checksum'].nil?

      version = node['crowd']['version']
      sums = crowd_checksum_map[version]

      fail "Crowd version #{version} is not supported by the cookbook" unless sums

      # Only standalone is supported by Crowd right now
      sums['tar']
    end

    # Returns SHA256 checksum map for Crowd artifacts
    # rubocop:disable Metrics/MethodLength
    def crowd_checksum_map
      {
        '2.12.0' => {
          'tar' => 'f53d9d6c1028c6f12ec4292579608fce5f926e40437d7795859e765584d2d6cd'
        },
        '2.11.2' => {
          'tar' => 'f6b539e100b09077e7448b3008364408d9437dd0f084ddd75fc7302549226c14'
        },
        '2.11.1' => {
          'tar' => '472b9b4884591e87dec4ad4412dd2fc01a36e5eb2347ef7b3db9b16bcb4deb89'
        },
        '2.10.1' => {
          'tar' => '86e9531c871be20761bcdfd6ea40d45ee74c7555609421283e69e1bfb1e784de'
        },
        '2.9.5' => {
          'tar' => '647c7cc956c2ac774e87ab21faceae59267d81533808c9b72d29d7f03a30f020'
        },
        '2.9.1' => {
          'tar' => '07c5eb9eaaf51a208cd0e9f0062abff6d239b4a6225cf8154436178fadde3489'
        },
        '2.8.8' => {
          'tar' => 'd2f095eac0ce0d778f556a2a7faa179eb008114015bd9dc2537707bfb020e3c0'
        },
        '2.8.4' => {
          'tar' => '7ae5a8c1928e997f8a220475db13f1fd374ee2b87e4a8d6cd5bb431378bfcf91'
        },
        '2.8.3' => {
          'tar' => 'dabfde01366c1f72d50440e69d38a3a2a5092a4cba525b3987af8d53b11a402c'
        },
        '2.8.2' => {
          'tar' => '250a46181cebe96624a59672b9f413d23e17195ca1fd6aafaff860951b5b89b4'
        },
        '2.8.0' => {
          'tar' => 'c857eb16f65ed99ab8b289fe671e3cea89140d42f85639304caa91a3ba9ade05'
        },
        '2.7.2' => {
          'tar' => '49361f2c7cbd8035c2fc64dfff098eb5e51d754b5645425770da14fc577f1048'
        },
        '2.6.7' => {
          'tar' => 'a40d2e3b5f14f44f1ced8046e42e1ea86475eab0cd4914486b4ad1bff79baf58'
        },
        '2.5.7' => {
          'tar' => '95bdba3729b7b7e489a8b198315518bcce1c9cc1cbb95ebd68b29bd31cf0efa5'
        },
        '2.4.10' => {
          'tar' => 'fcb7dde464068c82558bb6baf6d86542a3aec3a18d8fe965a230a42290cd7e11'
        },
		'3.0.0' => {
		  'tar' => 'ff8d62481f3df7d84ee9e030f2d4472ab4d59f81768217f7155638c4c272e291'
		},
		'3.0.1' => {
		  'tar' => '9987f758084006cfba75f6eb77f43315a5f25aed86a7f5f7d280ecf65f06ff9e'
		}
      }
    end
    # rubocop:enable Metrics/MethodLength
  end
end

::Chef::Recipe.send(:include, Crowd::Helpers)
::Chef::Resource.send(:include, Crowd::Helpers)
::Chef::Mixin::Template::TemplateContext.send(:include, Crowd::Helpers)
