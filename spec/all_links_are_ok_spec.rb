#!/usr/bin/env ruby

require "yaml"

each_config_file do |filename, path|
  RSpec.describe filename do
    config = YAML.load_file(path)
    link_results = find_links(config)
    link_results.each do |link_result|
      describe link_result.path do
        it "should not have a broken link to `#{link_result.link}`" do
          response = request_link(link_result.link)
          expect(response.code).to eql "200"
        end
      end
    end
  end
end

