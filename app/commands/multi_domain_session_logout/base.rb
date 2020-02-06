module MultiDomainSessionLogout
  class Base

    TOKEN_EXPIRATION_TIME = 60

    Result = ::Struct.new(:ok, :errors, :redirection)

    def initialize(request, return_path = nil)
      @request = request
      @redis = Redis.current
      @return_path = return_path
    end

    def call
      fail 'must be implemented'
    end

    private

    def token
      @token ||= @request.params['token'] || generate_token
    end

    def generate_token
      SecureRandom.base64(32).first(32)
    end

    def next_redirection
      next_domain = @redis.smembers(redis_token_redirections_path).first
      if next_domain.present?
        generate_domain_logout_path(next_domain)
      else
        @redis.get(redis_token_return_path)
      end
    end

    def generate_domain_logout_path(next_domain)
      Rails.application.routes.url_helpers.api_v1_logout_url(
        host: next_domain,
        protocol: 'http',
        port: 3000,
        params: { token: token }
      )
    end

    def redis_token_return_path
      "logins/#{token}/return_path"
    end

    def redis_token_redirections_path
      "logins/#{token}/redirections"
    end

  end
end
