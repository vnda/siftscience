class ApplicationController < ActionController::Base
  def status
    render text: 'OK'
  end

  private

  def require_authentication
    return unless Rails.env.production?
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["HTTP_USER"] && password == ENV["HTTP_PASSWORD"]
    end
  end
end
