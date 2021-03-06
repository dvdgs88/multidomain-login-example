module MultiDomainSessionLogout
  class Updater < Base

    def call
      current_domain = @request.host
      @redis.srem(redis_token_redirections_path, current_domain)

      @redis.expire(redis_token_redirections_path, TOKEN_EXPIRATION_TIME)

      Result.new(true, {}, next_redirection)
    end

  end
end
