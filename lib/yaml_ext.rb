require "erb"
require "yaml"
require "yaml_ext/version"

module YamlExt
  class << self
    def load_file(path)
      YAML.load(ERB.new(File.read(path), nil, "-").result(binding))
    end
  end
end
