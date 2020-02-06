# frozen_string_literal: true

module Api
  module V1
    class LogoutsController < ::ApplicationController

      def create
        ::MultiDomainSessionLogout::Updater.new(request).call.tap do |result|
          if result.ok
            logout
            redirect_to(result.redirection)
          else
            redirect_to(root_path)
          end
        end
      end

      private

      def logout
        session[:email] = nil
      end

    end
  end
end
