module MultiDomainSessionLogin
  class Base

    TOKEN_EXPIRATION_TIME = 60

    attr_accessor :email, :remember_me

    Result = ::Struct.new(:ok, :errors, :data)

    def initialize(request, email = nil, return_path = nil)
      @request = request
      @redis = Redis.current
      @email = email || @redis.get(redis_token_email_path)
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
        generate_domain_login_path(next_domain)
      else
        @redis.get(redis_token_return_path)
      end
    end

    def generate_domain_login_path(next_domain)
      Rails.application.routes.url_helpers.api_v1_login_url(
        host: next_domain,
        protocol: 'http',
        port: 3000,
        params: { token: token }
      )
    end

    def redis_token_return_path
      "logins/#{token}/return_path"
    end

    def redis_token_email_path
      "logins/#{token}/email"
    end

    def redis_token_redirections_path
      "logins/#{token}/redirections"
    end

    def generate_result_data
      { redirection: next_redirection, email: email }
    end

  end
end
