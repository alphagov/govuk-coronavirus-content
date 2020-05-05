#!/usr/bin/env ruby

require "yaml"
require "net/http"

exit_code = 0

def get_links(section)
  if section.is_a? Hash
    section.flat_map do |key, value|
      if entry_looks_like_a_link(key, value)
        [value]
      else
        get_links(value) || []
      end
    end
  elsif section.is_a? Array
    section.flat_map do |value|
      get_links(value) || []
    end
  end
end

def entry_looks_like_a_link(key, value)
  %w[href url link].any? { |suffix| key.end_with?(suffix) } &&
    value.is_a?(String) &&
    !value.include?(" ")
end

def get_absolute_link(relative_link)
  if relative_link.start_with?(/https?:\/\//)
    relative_link
  else
    ENV.fetch("LINK_BASE", "https://www.gov.uk") + relative_link
  end
end

def check_link(absolute_link)
  uri = URI(absolute_link)
  response = Net::HTTP.get_response(uri)
  if response.message == "OK"
    print "."
  else
    print "!"
  end
  {
    success: response.message == "OK",
    response: response,
    link: absolute_link,
  }
end

config = {}
Dir.glob("#{__dir__}/../content/*.yml") do |filename|
  basename = File.basename(filename)
  puts "Testing links in #{basename}..."

  config = YAML.load_file(filename)
  relative_links = get_links(config)
  absolute_links = relative_links.map { |link| get_absolute_link link }
  checked_links = absolute_links.map { |link| check_link link }
  puts ""
  good_links = checked_links.select { |result| result[:success] }
  bad_links = checked_links.reject { |result| result[:success] }

  if bad_links.empty?
    puts "All #{good_links.size} links in #{basename} are OK"
  else
    puts "Found #{bad_links.size} bad links (and #{good_links.size} OK links) in #{basename}"
    puts "\nStatus	Message	Link"
    bad_links.each do |result|
      puts "#{result[:response].code}	#{result[:response].message}	#{result[:link]}"
    end
    puts
    exit_code = 1
  end
end

exit exit_code
