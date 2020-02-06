module MultiDomainSessionLogout
  class Creator < Base

    ELIGIBLE_DOMAINS = %w[www.marsbased.mars www.martiantapas.mars www.ruby.mars].freeze

    def call
      @redis.sadd(redis_token_redirections_path, ELIGIBLE_DOMAINS)
      @redis.set(redis_token_return_path, @return_path)

      @redis.expire(redis_token_redirections_path, TOKEN_EXPIRATION_TIME)

      Result.new(true, {}, next_redirection)
    end

  end
end
