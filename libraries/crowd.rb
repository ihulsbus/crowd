# Crowd module
module Crowd
  # Crowd::Helpers module
  module Helpers
    class Crowd
      # rubocop:disable Metrics/AbcSize
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
          settings ||= node['crowd'].to_hash

          case settings['database']['type']
          when 'mysql'
            settings['database']['port'] ||= 3306
          when 'postgresql'
            settings['database']['port'] ||= 5432
          else
            Chef::Log.warn('Unsupported database type - Use a supported type or handle DB creation/config in a wrapper cookbook!')
          end
        end

        settings
      end
      # rubocop:enable Metrics/AbcSize
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

      raise "Crowd version #{version} is not supported by the cookbook" unless sums

      # Only standalone is supported by Crowd right now
      sums['tar']
    end

    # Returns SHA256 checksum map for Crowd artifacts
    # rubocop:disable Metrics/MethodLength
    def crowd_checksum_map
      {
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
        }
      }
    end
    # rubocop:enable Metrics/MethodLength
  end
end

::Chef::Recipe.send(:include, Crowd::Helpers)
::Chef::Resource.send(:include, Crowd::Helpers)
