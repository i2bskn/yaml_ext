require "spec_helper"

RSpec.describe YamlExt do
  let(:schema_path) { File.join(EXAMPLE_PATH, "schema.yml") }
  let(:schema) { YamlExt.load(schema_path) }

  it "has a version number" do
    expect(YamlExt::VERSION).not_to be nil
  end

  context ".load" do
    let(:expected) {
      {
        "type"  => "array",
        "items" => {
          "type" => "object",
          "required" => ["id", "name"],
          "properties" => {
            "id"   => { "type" => "integer" },
            "name" => { "type" => "string" },
            "tag"  => { "type" => "string" },
          },
        },
      }
    }

    subject {
      [
        "paths",
        "/users",
        "get",
        "responses",
        "200",
        "content",
        "application/json",
        "schema",
      ].inject(schema) { |s, k| s.fetch(k) }
    }

    it { is_expected.to eq(expected) }
  end

  context ".load_with_extended_nodes" do
    subject { ["components", "schemas", "User"].inject(schema) { |s, k| s.fetch(k) } }

    it { is_expected.to a_hash_including("type" => "object") }
  end

  context ".load_with_erb" do
    subject { ["info", "description"].inject(schema) { |s, k| s.fetch(k) } }

    it { is_expected.to eq(2) }
  end
end
