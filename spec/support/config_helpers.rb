def each_config_file
  Dir.glob("#{__dir__}/../../content/*.yml") do |path|
    filename = File.basename(path)
    yield filename, path
  end
end

LinkResult = Struct.new(:link, :path)

def find_links(section, path = "")
  if section.is_a? Hash
    section.flat_map do |key, value|
      if entry_looks_like_a_link(key, value)
        [LinkResult.new(value, "#{path}/#{key}")]
      else
        find_links(value, "#{path}/#{key}") || []
      end
    end
  elsif section.is_a? Array
    section.each_with_index.flat_map do |value, index|
      find_links(value, "#{path}[#{index}]") || []
    end
  end
end

def entry_looks_like_a_link(key, value)
  %w[href url link].any? { |suffix| key.end_with?(suffix) } &&
    value.is_a?(String) &&
    !value.include?(" ")
end

