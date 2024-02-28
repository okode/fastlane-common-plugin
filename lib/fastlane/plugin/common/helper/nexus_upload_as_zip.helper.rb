require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class NexusUploadAsZipHelper
      # class methods that you define here become available in your action
      # as `Helper::NexusUploadAsZipHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the nexus_upload_as_zip plugin helper!")
      end
    end
  end
end
