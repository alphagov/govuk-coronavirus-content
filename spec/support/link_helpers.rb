require "net/http"

def get_absolute_gov_uk_link(link)
  if link.start_with?(/https?:\/\//)
    link
  else
    ENV.fetch("LINK_BASE", "https://www.gov.uk") + link
  end
end

def request_link(link)
  uri = URI(get_absolute_gov_uk_link(link))
  Net::HTTP.get_response(uri)
end

