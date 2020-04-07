#!/usr/bin/env ruby

require "yaml"

Dir.glob("#{__dir__}/../content/*.yml") do |filename|
  begin
    YAML.load_file(filename)
  rescue StandardError => e
    puts "Failed to load YAML for '#{File.basename(filename)}' - is it well formed?"
    puts "Remember that YAML is fussy about characters like colons and quotes, so you might need to put some quotes around one of your values."
    puts ""
    puts "The error was: #{e.message}"
    exit 1
  end
end
