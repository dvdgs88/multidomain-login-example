module MultiDomainSessionable
  extend ActiveSupport::Concern

  def multidomain_login(user_id, redirection)
    MultiDomainSessionLogin::Creator.new(request, user_id, redirection).call
  end

  def multidomain_logout(redirection)
    MultiDomainSessionLogout::Creator.new(request, redirection).call
  end
end
