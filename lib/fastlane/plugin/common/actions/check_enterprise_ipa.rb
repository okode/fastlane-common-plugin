require 'fastlane/action'

module Fastlane
  module Actions
    class CheckEnterpriseIpaAction < Action
      def self.run(params)
        ipa_path = params[:ipa_path]
        expiration_threshold_days = params[:expiration_threshold_days]

        UI.message("🔒 Running enterprise ipa check")

        Actions::CheckIpaExpirationAction.run(
          ipa_path: ipa_path,
          threshold_days: expiration_threshold_days
        )
      end

      def self.description
        "Runs enterprise IPA validations"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :ipa_path,
            description: "Path to the .ipa file",
          ),
          FastlaneCore::ConfigItem.new(
            key: :expiration_threshold_days,
            description: "Number of days before expiration to trigger failure",
            default_value: 120,
            type: Integer
          )
        ]
      end

      def self.authors
        ["Okode"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
