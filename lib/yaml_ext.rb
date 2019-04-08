require "erb"
require "yaml"
require "yaml_ext/version"

module YamlExt
  class << self
    def load(path)
      resolve_ref_inner_json(load_file(path))
    end

    def load_file(path)
      parse_extended_node(load_yaml_file(path), path)
    end

    private

      def load_yaml_file(path)
        YAML.load(ERB.new(File.read(path), nil, "-").result)
      end

      def parse_extended_node(node, path)
        case node
        when Hash
          node.each_with_object({}) { |(k, v), obj|
            if k == "$ref" && v.is_a?(String) && !v.start_with?("#/")
              value = load_file(File.expand_path(v, File.dirname(path)))
              case value
              when Hash
                obj = {} unless obj.is_a?(Hash)
                obj.merge!(value)
              when Array
                obj = [] unless obj.is_a?(Array)
                obj.concat(value)
              else
                obj = value
              end
            else
              obj = {} unless obj.is_a?(Hash)
              obj[k] = parse_extended_node(v, path)
            end
          }
        when Array
          node.map { |n| parse_extended_node(n, path) }
        else
          node
        end
      end

      def resolve_ref_inner_json(node, node_tree = nil)
        node_tree ||= node

        case node
        when Hash
          node.each_with_object({}) { |(k, v), obj|
            if k == "$ref" && v.is_a?(String) && v.start_with?("#/")
              value = v.split("/")[1..-1].inject(node_tree) { |nodes, key| nodes.fetch(key) }
              case value
              when Hash
                obj = {} unless obj.is_a?(Hash)
                obj.merge!(value)
              when Array
                obj = [] unless obj.is_a?(Array)
                obj.concat(value)
              else
                obj = value
              end
            else
              obj = {} unless obj.is_a?(Hash)
              obj[k] = resolve_ref_inner_json(v, node_tree)
            end
          }
        when Array
          node.map { |n| resolve_ref_inner_json(n, node_tree) }
        else
          node
        end
      end
  end
end
