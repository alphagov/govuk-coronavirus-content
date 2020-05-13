#!/usr/bin/env ruby

require "yaml"
RSpec.describe 'Content YAML files' do
  Dir.glob("#{__dir__}/../content/*.yml") do |filename|
    basename = File.basename(filename)
    describe basename do
      it 'should be able to load the YAML content without error' do
        expect(filename).to load_yaml_file_without_error
      end
    end
  end
end
