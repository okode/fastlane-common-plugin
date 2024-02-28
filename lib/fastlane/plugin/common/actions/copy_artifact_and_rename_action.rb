require 'fastlane/action'

module Fastlane
  module Actions
    class CopyArtifactAndRenameAction < Action
      def self.run(params)
        app_name = params[:app_name]
        artifact_path = params[:artifact_path]
        dist_artifacts_path = params[:dist_artifacts_path]
        default_dir_relative_to_workspace = params[:default_dir_relative_to_workspace]

        if app_name
          target_path = dist_artifacts_path || "../../../#{default_dir_relative_to_workspace}"
          artifact_extension = File.extname(artifact_path).shellescape
          new_artifact_name = "#{app_name}-#{get_app_version()}#{artifact_extension}"
          sh("mkdir -p #{target_path}")
          sh("cp \"#{artifact_path}\" \"#{target_path}/#{new_artifact_name}\"")
        else
          target_path = dist_artifacts_path || "../../#{default_dir_relative_to_workspace}"
          copy_artifacts(target_path: target_path, artifacts: [artifact_path])
        end
      end

      def self.description
        "Copies custom artifacts with optional renaming based on provided parameters"
      end

      def self.authors
        ["Okode"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :app_name,
                                       description: "App name",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :artifact_path,
                                       description: "Path to the artifact",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :dist_artifacts_path,
                                       description: "Path to the distribution artifacts",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :default_dir_relative_to_workspace,
                                       description: "Default directory relative to workspace",
                                       optional: true)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end