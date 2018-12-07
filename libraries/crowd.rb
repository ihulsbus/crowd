# frozen_string_literal: true
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
      sum = crowd_checksum_map[version]

      raise "Crowd version #{version} is not supported by the cookbook" unless sum

      sum
    end

    # Returns SHA256 checksum map for Crowd artifacts
    def crowd_checksum_map
      {
        '3.3.0' => '2f8a37d1a8d920b710e92cd94997492b56b90d85793c3d90d03e5b6335ef5368',
        '3.2.6' => '2b1ab2d80fbfe5962670f94cf60712d5a045de3a26a16cc2a778142de031f292',
        '3.2.5' => '86464c20d2922c98f5b0bc3d1ddf854b23efac6da5fffc2604958b9610ec13c1',
        '3.2.3' => '89dc92c8bff90a9e5cd41a06cbbdbae77a346ba071bd00bc0464700cbe40171f',
        '3.2.2' => '5903f07ff47d12d1cf1453123a5e3d99c016a554cf8088d0d45fbf95747d6ac9',
        '3.2.1' => 'c9b045deb86eaae486ce930e33488fea16e2e117acda488549a7f792203f6b08',
        '3.2.0' => '4782556bb6532bcd4b11ebe79e219707300686eb55dd3521fb05ca4489f0df71',
        '3.1.5' => 'df8a3a0453ca2759243b9df0386a9f1a9920e743f18a6055bc504b274da1a9af',
        '3.1.4' => '5718cb49df51d5d6f6b769fc6c1f4a2c0dfd6cfdc089ec48bc5c85f13b2f2dad',
        '3.1.3' => '417b1d993b00bcc5d52ba5f072618c9c22487a92b0373c52d26b22fd5e34ef3d',
        '3.1.2' => '71be4e94ff253b3b76ef4dfbb14fdbeb643ab0adc113d8df64472034e807d45e',
        '3.1.1' => '4058fde9880abeba2d6d90c66ae3b4b488b3fe24511aea1926835bb2e51c816e',
        '3.0.3' => '18465590b3dba9df01b3be1e941a452f9aafd9134c63d822ad6b015a1e70bab8',
        '3.0.2' => '84acbfbeed4dd50b72d6da0a5eb0952a0d70a9c0cc7c8d42fe8e3d72e6210a45',
        '3.0.1' => '9987f758084006cfba75f6eb77f43315a5f25aed86a7f5f7d280ecf65f06ff9e',
        '3.0.0' => 'ff8d62481f3df7d84ee9e030f2d4472ab4d59f81768217f7155638c4c272e291',
        '2.12.0' => 'f53d9d6c1028c6f12ec4292579608fce5f926e40437d7795859e765584d2d6cd',
        '2.11.2' => 'f6b539e100b09077e7448b3008364408d9437dd0f084ddd75fc7302549226c14',
        '2.11.1' => '472b9b4884591e87dec4ad4412dd2fc01a36e5eb2347ef7b3db9b16bcb4deb89',
        '2.11.0' => '2829546939aa6772dab65958d518a64631f4ec1ad8d4d9eda39c11e3ab12e35f',
        '2.10.3' => 'ee513d00fed65221e5a0fc93c21954e760aee5500aa35667f27358edbfaa172b',
        '2.10.2' => '58f2f359022f829f1e3ce882b6f9ae9f3b44d177cbad8a2d5ac1d840436b4f7b',
        '2.10.1' => '86e9531c871be20761bcdfd6ea40d45ee74c7555609421283e69e1bfb1e784de',
        '2.9.7' => '08a862b5e69d79845ceba16f0c1b6cea69cf97874afdb1c8cd72665f096d0138',
        '2.9.5' => '647c7cc956c2ac774e87ab21faceae59267d81533808c9b72d29d7f03a30f020',
        '2.9.1' => '07c5eb9eaaf51a208cd0e9f0062abff6d239b4a6225cf8154436178fadde3489',
        '2.8.8' => 'd2f095eac0ce0d778f556a2a7faa179eb008114015bd9dc2537707bfb020e3c0',
        '2.8.4' => '7ae5a8c1928e997f8a220475db13f1fd374ee2b87e4a8d6cd5bb431378bfcf91',
        '2.8.3' => 'dabfde01366c1f72d50440e69d38a3a2a5092a4cba525b3987af8d53b11a402c',
        '2.8.2' => '250a46181cebe96624a59672b9f413d23e17195ca1fd6aafaff860951b5b89b4',
        '2.8.0' => 'c857eb16f65ed99ab8b289fe671e3cea89140d42f85639304caa91a3ba9ade05',
        '2.7.2' => '49361f2c7cbd8035c2fc64dfff098eb5e51d754b5645425770da14fc577f1048',
        '2.7.1' => '8f6c08f8d23c2eb25ec6428d676316e8606c240e6d9bdf1ec220cff890afcbff',
        '2.7.0' => '68642e03a865a0f742c7f3f219d2c055a2b27d9fb2d01cd4464c1c8ad9d515da',
        '2.6.7' => 'a40d2e3b5f14f44f1ced8046e42e1ea86475eab0cd4914486b4ad1bff79baf58',
        '2.6.5' => 'ab37f37d5f17be23cff16b3888440fb7a355d29560b86c510b27372766672ec3',
        '2.6.4' => '42bc83f1606828c791496000c4da7ce4e42d616a98a65d6a31506295bed12660',
        '2.6.3' => 'c9570268f794452f1d23d94dac2c2e424a18081e6e80f4212576d32570796e40',
        '2.6.2' => '4c7a869ac1656041d5034686557f9ccd2ca8844cbdcf8e377be5ce773d45cabc',
        '2.6.1' => '40949ab98fffc1363b9ba203cd2e8fef4bbc3dcd909f7aeaff47af42f2dbfff6',
        '2.6.0' => '524e167cd4be95bd6c1cbaa25b0f6f88a8e92be26f9634cba5b38e18a120289c',
        '2.5.7' => '95bdba3729b7b7e489a8b198315518bcce1c9cc1cbb95ebd68b29bd31cf0efa5',
        '2.5.5' => 'ca70434ffcbcebac693ca0c593be18078c964fcff8d89c31917743aa25461236',
        '2.5.4' => 'a622fc715c93c7893a206c838a9f169f9cf108c0ed7b73657522d990fbd86a1c',
        '2.5.3' => '6d96f31cbaac850f3cd96540d027870b4aaea06b1fe3c9451551935a9564caaf',
        '2.5.2' => '2cfa9e453495be8c7ea45d033f8af549e2d77a47b44ede548505702c4d70777d',
        '2.5.1' => '5125f5c7e73cfe621720b5c9883184146620ff788bae2927c12a6b8c262ccdb6',
        '2.5.0' => '7d0cc3a910a44551c6fce83dfa97945ab0b4544c52d84eb41d18951bc9e190ed',
        '2.4.10' => 'fcb7dde464068c82558bb6baf6d86542a3aec3a18d8fe965a230a42290cd7e11',
        '2.4.2' => '49dde930187563bb10614f29920d2563c68ba12c94abda5d5689e5da3bb4cbd1',
        '2.4.1' => 'e9622d384f2226c9cd230361a158c274606fab18a4ef8bba7b909ad55ca5049e',
        '2.4.0' => 'e90ac9692798847c76d411a3158f276a0cfb2b514e32d77debe4cd87f0581675',
        '2.3.9' => '3cfa4c1b5dedc9eaf3c3b8d2ca92db91453fa9c38d6787d45fd335b460926941',
        '2.3.7' => 'b73cc3e43f8c0704a5646eef6907657e1646bcd018ac001631fca19e0c900c02',
        '2.3.6' => '95b22a89927bad5d480fefc16392ae957cb7393d7c304ba680d3b83969357bf1',
        '2.3.4' => '4474e3bbd71864cd9477dfe7ce652c351fd8a9a0c15f9009d3b2608166309f81',
        '2.3.3' => 'de85bd86bf4f379e6f0f7f6c2d8d7900bc6106ee65a9c39c66edbdb2141305e5',
        '2.3.2' => '2de1144a5ae671d797896c0826921e45db462aafbc7fb76a5248a32deb0a9521',
        '2.3.1' => '32e4d526e9d8b094067549cc08eda2d3421202d87a39b330f0189d7c8317d7db',
        '2.2.9' => '282535fe8873553575436af1cc9bd634c431ed86d958ad5ab8e1ad330c739580',
        '2.2.7' => '2c15ad0c3966f41ee7d0253a143a88b2784259110b002fe41415a83fb41a3ef7',
        '2.2.4' => '2f397a407fdff7996a072302dbf8585541f0ed26b91cfb2030dfd5d110c6c6fa',
        '2.2.2' => '0f66866ddb3d266d197510abb310e05aa0308e7aa955bb63120b552f02db50c4',
        '2.1.2' => '62db98ff60bd53bdd6f90c54a5a66d34fc7861f72de415cae66b46ec0e3d8149',
        '2.1.1' => '2f6f67b5e47007fb9ee95b342e7a6d8686a61c72f7e4607144a489d2940bd206',
        '2.1.0' => '9182d4956fd60f92c3bc13d6de4e9905e1783a897bae621017a67eb20bbc5455',
        '2.0.9' => '9aca21e8ca8cf2c7b676c83dfcd35d9dd8cfe9960afa131173e5e9d92c26aa1f',
        '2.0.7' => '2cec97a124f3a0bf7f2c5838a2b2d04d2d1351c406133a66e155e92f3ab97500',
        '2.0.6' => '882d3cbdb644afbbea8dec661e8d766bbbd90bf22efa0a9b2052d2973848242b',
        '2.0.5' => 'a53688b1156b36c6509c7fae082fa8f8c1c397ceabf752d89dd69674ea473082',
        '2.0.4' => 'dcc486625e96925e95961bf0b2b6a1d815d76a89891b18f7706c4a7263f34c5f',
      }
    end
  end
end

::Chef::Recipe.send(:include, Crowd::Helpers)
::Chef::Resource.send(:include, Crowd::Helpers)
::Chef::Mixin::Template::TemplateContext.send(:include, Crowd::Helpers)
