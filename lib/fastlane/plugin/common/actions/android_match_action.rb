require 'fastlane/action'
require 'fastlane_core'

module Fastlane
  module Actions
    class AndroidMatchAction < Action
      def self.run(params)
        keystore = params[:keystore]
        type = params[:type]

        if type == 'debug'
          keystore = ENV['ANDROID_MATCH_DEBUG_KEYSTORE']
        elsif type == 'release'
          keystore = ENV['ANDROID_MATCH_RELEASE_KEYSTORE']
        elsif type
          raise 'Invalid type #{type}. Valid values: debug|release.'
        end

        raise 'Missing keystore #{keystore}.' unless keystore

        raise 'The keystore already exists. If you want to redownload it, please run with the --force flag.' if !params[:force] && File.exist?(keystore)

        temp_dir = Dir.mktmpdir
        git_url = ENV['ANDROID_MATCH_URL']
        git_branch = ENV['ANDROID_MATCH_BRANCH']

        sh("git clone --branch #{git_branch} #{git_url} #{temp_dir}")
        FileUtils.cp("#{temp_dir}/#{keystore}", '../')
        FileUtils.rm_rf(temp_dir)
      end

      def self.description
        "Android Match Keystore Action"
      end

      def self.authors
        ["Okode"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :keystore,
                                       description: "Keystore",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :type,
                                       description: "Type (debug/release)",
                                       optional: true,
                                       default_value: "debug"),
          FastlaneCore::ConfigItem.new(key: :force,
                                       description: "Force clone",
                                       optional: true,
                                       is_string: false,
                                       default_value: false)
        ]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
