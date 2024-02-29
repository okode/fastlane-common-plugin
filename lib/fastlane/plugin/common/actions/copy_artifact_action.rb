require 'fastlane/action'

module Fastlane
  module Actions
    class CopyArtifactAction < Action
      def self.run(params)
        target_path = params[:target_path]
        artifact_path = params[:artifact_path]
        new_artifact_name = params[:new_artifact_name]

        if new_artifact_name
          artifact_extension = File.extname(artifact_path).shellescape
          new_artifact_name_with_extension = "#{options[:new_artifact_name]}#{artifact_extension}"
          sh("mkdir -p #{target_path}")
          sh("cp \"#{artifact_path}\" \"#{target_path}/#{new_artifact_name_with_extension}\"")
        else
          other_action.copy_artifacts(target_path: target_path, artifacts: [artifact_path])
        end
      end

      def self.description
        "Copies artifacts with optional renaming based on provided parameters"
      end

      def self.authors
        ["Okode"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :target_path,
                                       description: "Target path",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :artifact_path,
                                       description: "Path to the artifact",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :new_artifact_name,
                                       description: "New artifact name",
                                       optional: true),
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end