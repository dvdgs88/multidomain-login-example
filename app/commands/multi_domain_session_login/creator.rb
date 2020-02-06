module MultiDomainSessionLogin
  class Creator < Base

    ELIGIBLE_DOMAINS = %w[www.marsbased.mars www.martiantapas.mars www.ruby.mars].freeze

    def call
      @redis.sadd(redis_token_redirections_path, ELIGIBLE_DOMAINS)
      @redis.set(redis_token_return_path, @return_path)
      @redis.set(redis_token_email_path, @email)

      @redis.expire(redis_token_redirections_path, TOKEN_EXPIRATION_TIME)

      Result.new(true, {}, generate_result_data)
    end

  end
end
