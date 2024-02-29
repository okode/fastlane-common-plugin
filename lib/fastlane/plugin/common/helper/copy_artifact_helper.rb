require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class CopyArtifactHelper
      # class methods that you define here become available in your action
      # as `Helper::CopyArtifact.your_method`
      #
      def self.show_message
        UI.message("Hello from the copy_artifact plugin helper!")
      end
    end
  end
end
