require 'fastlane/action'
require 'fastlane_core'

module Fastlane
  module Actions
    class UploadAzureArtifactsAction < Action
      def self.run(params)
        artifact = params[:artifact]
        if params[:as_zip]
          artifact_extension = File.extname(artifact).shellescape[1..-1]
          output_file_path = "#{artifact}.zip"
          sh("zip -r #{output_file_path} #{artifact}")
          artifact = output_file_path
        end

        command = [
          "az artifacts universal publish",
          "--organization #{params[:organization].shellescape}",
          "--feed #{params[:feed].shellescape}",
          "--name #{params[:name].shellescape}",
          "--version #{params[:version].shellescape}",
          "--path #{artifact.shellescape}",
          "--description #{params[:description].shellescape}"
        ]

        command << "--project #{params[:project].shellescape}" if params[:project]
        command << "--scope project" if params[:scope] == "project"

        Fastlane::Actions.sh(command.join(' '), log: params[:verbose])
      end

      def self.description
        "Uploads artifact to Azure Artifacts"
      end

      def self.authors
        ["Your Name"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :artifact,
                                       description: "Path to the artifact to upload",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :name,
                                       description: "Package name",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :version,
                                       description: "Package version",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :organization,
                                       description: "Azure DevOps organization URL",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :feed,
                                       description: "Azure Artifacts feed name",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :description,
                                       description: "Package description",
                                       optional: true,
                                       default_value: ""),
          FastlaneCore::ConfigItem.new(key: :project,
                                       description: "Azure DevOps project name",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :scope,
                                       description: "Scope of the feed (project or organization)",
                                       optional: true,
                                       default_value: "organization"),
          FastlaneCore::ConfigItem.new(key: :as_zip,
                                       description: "Flag to indicate if artifact should be zipped before upload",
                                       optional: false,
                                       is_string: false,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :verbose,
                                       description: "Verbose output",
                                       optional: true,
                                       is_string: false,
                                       default_value: false)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
