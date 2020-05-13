#!/usr/bin/env ruby

require 'yaml'
require 'jsonnet'
RSpec.describe 'Content YAML files' do
  Dir.glob("#{__dir__}/../content/*.yml") do |filename|
    basename = File.basename(filename)
    describe basename do

      let(:page_type) { basename =~ /coronavirus_landing_page/ ? :landing : :hub }
      let(:schema) do
        file_path = File.expand_path("../schema/coronavirus_#{page_type}_page.jsonnet", __dir__)
        Jsonnet.load(file_path)
      end
      let(:yaml) { YAML.load_file(filename) }

      it 'can be loaded and matches schema' do
        # Running both expectations together as if first fails the second will fail with the same error
        expect(filename).to load_yaml_file_without_error
        expect(schema).to validate_yaml_in(yaml)
      end
    end
  end
end
