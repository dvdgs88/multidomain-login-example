# frozen_string_literal: true

module Api
  module V1
    class LoginsController < ::ApplicationController

      def create
        ::MultiDomainSessionLogin::Updater.new(request).call.tap do |result|
          if result.ok
            login(result.data[:email])
            redirect_to(result.data[:redirection])
          else
            redirect_to(root_path)
          end
        end
      end

      private

      def login(email)
        session[:email] = email
      end

    end
  end
end
