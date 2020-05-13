require 'rspec/expectations'

RSpec::Matchers.define :load_yaml_file_without_error do |expected|
  match do |actual|
    @error = nil
    begin
      YAML.load_file(actual)
    rescue StandardError => e
      @error = e
    end
    expect(@error).to be_nil
  end
  failure_message do |actual|
    basename = File.basename(actual)
    <<~MESSAGE
    Failed to load YAML for '#{basename}' - is it well formed?
    Remember that YAML is fussy about characters like colons and quotes, so you might need to put some quotes around one of your values.

    The error was:
      #{@error.message}"
    MESSAGE
  end
end
