require "json"
require "http"
require "uri"
require "base64"
require "habitat"
require "dexter"

require "./easypost/object"
require "./easypost/resource"
require "./easypost/*"

module EasyPost
  VERSION = "0.1.0"

  Habitat.create do
    setting api_key : String
    setting api_base : String = "https://api.easypost.com"
  end

  def self.make_request(method : String, path : String, body = nil)
    headers = HTTP::Headers{
      "User-Agent"    => "EasyPost/v2 CrystalClient/#{VERSION} Crystal/#{Crystal::VERSION}-#{Crystal::BUILD_COMMIT}",
      "Content-Type"  => "application/json",
      "Authorization" => "Basic #{Base64.strict_encode(EasyPost.settings.api_key)}",
    }

    response = HTTP::Client.new(URI.parse(EasyPost.settings.api_base)).exec(
      method.upcase,
      path,
      headers,
      body.to_json
    )

    if (400..599).includes?(response.status_code)
      error = JSON.parse(response.not_nil!.body)["error"]
      raise Error.new(error["message"].as_s, response.status_code, error["code"].as_s, error["errors"])
    end

    response.body
  rescue JSON::ParseException
    raise RuntimeError.new("Invalid response object from API, unable to decode.\n#{response.not_nil!.body}")
  end
end
