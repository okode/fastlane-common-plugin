lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/common/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-common'
  spec.version       = Fastlane::Common::VERSION
  spec.author        = 'Virginia Vila'
  spec.email         = '106952548+v-vila@users.noreply.github.com'

  spec.summary       = 'common utilities'
  # spec.homepage      = "https://github.com/<GITHUB_USERNAME>/fastlane-plugin-common"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 3.1'

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  # spec.add_dependency 'your-dependency', '~> 1.0.0'
end
