#!/usr/bin/env ruby

require "yaml"

each_config_file do |filename, path|
  RSpec.describe filename do
    it "should be able to load the YAML content without error" do
      error = nil
      begin
        YAML.load_file(path)
      rescue StandardError => e
        error = e
      end
      expect(e).to be_nil, lambda {
        <<~MESSAGE
        Failed to load YAML for '#{filename}' - is it well formed?
        Remember that YAML is fussy about characters like colons and quotes, so you might need to put some quotes around one of your values.

        The error was: #{error.message}"
        MESSAGE
      }
    end
  end
end

