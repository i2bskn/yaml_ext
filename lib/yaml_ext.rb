require "erb"
require "yaml"
require "yaml_ext/version"

module YamlExt
  class << self
    def load(path)
      parse_nodes(:ref_inner_node, load_with_extended_nodes(path), path)
    end

    def load_with_extended_nodes(path)
      parse_nodes(:ref_extended_node, load_with_erb(path), path)
    end

    def load_with_erb(path)
      YAML.safe_load(ERB.new(File.read(path), trim_mode: "-").result)
    end

    private

      def parse_nodes(type, node, path, node_tree = nil, node_path = [])
        node_tree ||= node.dup

        case node
        when Hash
          send(type, node, path, node_tree, node_path)
        when Array
          node.map.with_index { |n, idx|
            parse_nodes(type, n, path, node_tree, node_path.dup.push(idx))
          }
        else
          node
        end
      end

      def ref_inner_node(node, path, node_tree = nil, node_path = [])
        node.each_with_object({}) do |(k, v), obj|
          if k == "$ref" && v.is_a?(String) && v.start_with?("#/")
            value = resolve_inner_ref(v, path, node_tree, node_path)

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
            obj[k] = parse_nodes(:ref_inner_node, v, path, node_tree, node_path.dup.push(k))
          end
        end
      end

      def ref_extended_node(node, path, node_tree = nil, node_path = [])
        node.each_with_object({}) do |(k, v), obj|
          if k == "$ref" && v.is_a?(String) && !v.start_with?("#/")
            value = load_with_extended_nodes(File.expand_path(v, File.dirname(path)))
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
            obj[k] = parse_nodes(:ref_extended_node, v, path, node_tree, node_path.dup.push(k))
          end
        end
      end

      def resolve_inner_ref(value, path, node_tree, node_path)
        ref_path = value.split("/")[1..-1]
        ref_value = ref_path.inject(node_tree) { |nodes, idx| nodes.fetch(idx) }
        resolved_value = parse_nodes(:ref_inner_node, ref_value, path, node_tree, ref_path)

        node_path.each.with_index(1) do |k, i|
          if node_path.size > i
            node_tree = node_tree[k]
          else
            node_tree[k] = resolved_value
          end
        end

        resolved_value
      end
  end
end
