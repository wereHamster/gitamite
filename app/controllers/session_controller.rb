
require 'rubygems'
require 'net/ldap'

class SessionController < ApplicationController

	def login
		ldap = Net::LDAP.new
		ldap.host = GitamiteConfig["ldap_host"]
		ldap.port = "636"

		base = GitamiteConfig["ldap_base"]
		ldap.encryption :method => :simple_tls
		ldap.auth "uid=#{params[:uid]},#{base}", params[:password]

		if ldap.bind
			session[:uid] = params[:uid]
		end

		begin
			redirect_to :back
		rescue ActionController::RedirectBackError
			redirect_to root_path
		end
	end

	def logout
		reset_session

		begin
			redirect_to :back
		rescue ActionController::RedirectBackError
			redirect_to root_path
		end
	end

end
