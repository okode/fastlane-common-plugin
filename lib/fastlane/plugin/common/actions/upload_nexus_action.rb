require 'fastlane/action'
require 'fastlane_core'

module Fastlane
  module Actions
    class UploadNexusAction < Action
      def self.run(params)
        artifact = params[:artifact]
        if params[:as_zip]
          artifact_extension = File.extname(artifact).shellescape[1..-1]
          output_file_path = "#{artifact}.zip"
          sh("zip -r #{output_file_path} #{artifact}")
          classifier = params[:repo_classifier] ? "#{params[:repo_classifier]}-#{artifact_extension}" : artifact_extension
          artifact = output_file_path
        else
          classifier = params[:repo_classifier]
        end

        other_action.nexus_upload(
          nexus_version: params[:nexus_version],
          mount_path: params[:mount_path],
          file: artifact,
          repo_id: params[:repo_id],
          repo_group_id: params[:repo_group_id],
          repo_project_name: params[:repo_project_name],
          repo_project_version: params[:repo_project_version],
          repo_classifier: classifier,
          endpoint: params[:endpoint],
          username: params[:username],
          password: params[:password],
          verbose: params[:verbose]
        )
      end

      def self.description
        "Uploads artifact as zip to Nexus repository"
      end

      def self.authors
        ["Okode"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :artifact,
                                       description: "Path to the artifact to upload",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :repo_project_version,
                                       description: "Repo project version",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :repo_classifier,
                                       description: "Repo classifier for the artifact",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :as_zip,
                                       description: "Flag to indicate if artifact should be zipped before upload",
                                       optional: false,
                                       is_string: false,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :nexus_version,
                                       description: "Nexus version",
                                       optional: true,
                                       is_string: false,
                                       default_value: 3),
          FastlaneCore::ConfigItem.new(key: :mount_path,
                                       description: "Mount path",
                                       optional: false,
                                       default_value: ''),
          FastlaneCore::ConfigItem.new(key: :repo_id,
                                       description: "Repository ID",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :repo_group_id,
                                       description: "Repository group ID",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :repo_project_name,
                                       description: "Repository project name",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :endpoint,
                                       description: "Nexus endpoint URL",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :username,
                                       description: "Nexus username",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :password,
                                       description: "Nexus password",
                                       optional: false),
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
