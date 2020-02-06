class SessionsController < ApplicationController
  include MultiDomainSessionable

  def index
  end

  def create
    redirect_to(multidomain_login(params[:email], root_url).data[:redirection])
  end

  def destroy
    redirect_to(multidomain_logout(root_url).redirection)
  end

end