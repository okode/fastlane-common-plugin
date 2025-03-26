require 'fastlane/action'
require 'fastlane_core'
require 'fastlane_core/ui/ui'

module Fastlane
  module Actions
    class UploadAzureArtifactsAction < Action
      def self.run(params)
        path = params[:path]
        if params[:as_zip]
          output_file_path = "#{path}.zip"
          sh("zip -r #{output_file_path} #{path}")
          path = output_file_path
        end

        organization = params[:organization] || 'https://dev.azure.com/devopsmapfre/'
        scope = params[:scope] || 'project'
        project = params[:project] || 'devopsmapfre'
        description = params[:description] || params[:name]

        command = [
          "az artifacts universal publish",
          "--organization #{organization.shellescape}",
          "--feed #{params[:feed].shellescape}",
          "--scope #{scope.shellescape}",
          "--name #{params[:name].shellescape}",
          "--version #{params[:version].shellescape}",
          "--path #{path.shellescape}",
          "--description #{description.shellescape}",
          "--project #{project.shellescape}"
        ]

        begin
          Fastlane::Actions.sh(command.join(' '), log: params[:verbose])
        rescue FastlaneCore::Interface::FastlaneShellError => e
          UI.error("Command failed: #{command.join(' ')}")
          UI.error("Error message: #{e.message}")
          UI.error("Backtrace: #{e.backtrace.join("\n")}")
          raise e
        end
      end

      def self.description
        "Uploads artifact to Azure Artifacts"
      end

      def self.authors
        ["Okode"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :path,
                                       description: "Path to the artifact to upload",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :name,
                                       description: "Package name",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :version,
                                       description: "Package version",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :feed,
                                       description: "Azure Artifacts feed name",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :organization,
                                       description: "Azure DevOps organization URL",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :description,
                                       description: "Package description",
                                       optional: true,
                                       default_value: ""),
          FastlaneCore::ConfigItem.new(key: :project,
                                       description: "Azure DevOps project name",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :scope,
                                       description: "Scope of the feed",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :as_zip,
                                       description: "Flag to indicate if artifact should be zipped before upload",
                                       optional: true,
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
