require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class CopyArtifactAndRenameHelper
      # class methods that you define here become available in your action
      # as `Helper::CopyArtifactAndRenameHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the copy_artifact_and_rename plugin helper!")
      end
    end
  end
end
