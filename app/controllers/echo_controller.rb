class EchoController < ApplicationController
  def index
    render json: { env_headers: hashified_request_env_headers }
  end

  private

  def hashified_request_env_headers
    request.headers.inject({}) do |acc, item|
      key, value = item
      if key.start_with?('HTTP_') || ActionDispatch::Http::Headers::CGI_VARIABLES.include?(key)
        acc[key] = value
      end
      acc
    end
  end
end
