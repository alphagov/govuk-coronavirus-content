#!/usr/bin/env ruby

require "yaml"
require "net/http"

each_config_file do |filename, path|
  RSpec.describe "The #{filename} config file" do
    config = YAML.load_file(path)
    link_results_by_host = find_links(config).group_by { |link_result| link_result.uri.host }
    link_results_by_host.each do |host, link_results|
      describe "links to #{host}" do
        http = Net::HTTP.new(host, 443)

        before :all do
          http.use_ssl = true
          http.open_timeout = 10
          http.start
        end

        after :all do
          http.finish
        end

        link_results.each do |link_result|
          describe "at #{link_result.path}" do
            it "should not have a broken link to `#{link_result.uri}`" do
              response = http.request_get link_result.uri.request_uri
              expect(response.code).to eql "200"
            end
          end
        end
      end
    end
  end
end

