
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "yaml_ext/version"

Gem::Specification.new do |spec|
  spec.name          = "yaml_ext"
  spec.version       = YamlExt::VERSION
  spec.authors       = ["i2bskn"]
  spec.email         = ["i2bskn@gmail.com"]

  spec.summary       = %q{Multiple YAML Loader.}
  spec.description   = %q{Multiple YAML Loader.}
  spec.homepage      = "https://github.com/i2bskn/yaml_ext"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
