require 'fastlane/action'
require 'fastlane_core'
require 'date'
require 'tmpdir'
require 'plist'

module Fastlane
  module Actions
    class CheckIpaExpirationAction < Action
      def self.run(params)
        
        UI.user_error!("You must provide a valid value for 'threshold_days'") unless params[:threshold_days]

        ipa_path = params[:ipa_path]
        threshold_days = params[:threshold_days].to_i
    
        UI.user_error!("You must provide a valid .ipa path") unless ipa_path && File.exist?(ipa_path)
    
        Dir.mktmpdir do |tmp_dir|
          sh("unzip -q '#{ipa_path}' -d '#{tmp_dir}'")
    
          profile_path = Dir["#{tmp_dir}/Payload/*.app/embedded.mobileprovision"].first
          UI.user_error!("No embedded.mobileprovision file found in the .ipa") unless profile_path
    
          plist_output = sh("security cms -D -i '#{profile_path}'")
          expiration_line = plist_output.lines.find { |line| line.include?("ExpirationDate") }
    
          require 'plist'
          profile_data = Plist.parse_xml(plist_output)
          expiration_date = profile_data['ExpirationDate']
    
          days_left = (expiration_date.to_date - Date.today).to_i
    
          UI.message("📆 Provisioning profile expires on #{expiration_date} (in #{days_left} days)")
    
          if days_left <= threshold_days
            UI.user_error!("🚨 The provisioning profile expires in less than #{threshold_days} days.")
          else
            UI.success("✅ The provisioning profile is valid for more than #{threshold_days} days.")
          end
        end
      end

      def self.description
        "Checks the expiration date of the provisioning profile embedded in an IPA"
      end

      def self.authors
        ["Okode"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :ipa_path,
                                       description: "Path to the .ipa file",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :threshold_days,
                                       description: "Number of days before expiration to trigger failure",
                                       optional: false)
        ]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
