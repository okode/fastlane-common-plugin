require 'fastlane/action'
require 'fastlane_core'

module Fastlane
  module Actions
    class SetAppEnvironmentAction < Action
      def self.run(options)
        unless options[:env]
          raise "Environment not provided"
        end

        sh("jq '{ \"#{options[:env]}\": .#{options[:env]} }' #{options[:env_file_path]} > environments.tmp.json && mv environments.tmp.json #{options[:env_file_path]}")
      end

      def self.description
        "Sets the environment"
      end

      def self.authors
        ["Okode"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :env,
                                       description: "Environment",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :env_file_path,
                                       description: "Path to the environment file",
                                       optional: true)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
