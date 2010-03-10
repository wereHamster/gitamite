
require 'rubygems'
require 'net/ldap'

class PermissionController < ApplicationController

	def index
		ldap = Net::LDAP.new
		ldap.host = GitamiteConfig["ldap_host"]
		ldap.port = "636"

		base = GitamiteConfig["ldap_base"]
		ldap.encryption :method => :simple_tls

		filter = Net::LDAP::Filter.eq("uid", "*#{params[:search]}*")
		@perms = []
		ldap.search(:base => base, :filter => filter, :attributes => [:uid]) do |entry|
			@perms.push(entry)
			return if @perms.length > 10
		end
	end

	def update
		redirect_to(:controller => :repository, :action => :show, :protocol => "https://")
	end

	def create
		@repo = Repository.find(:first, :conditions => { :owner => params[:uid], :name => params[:repository_id] }) 
		@perm = Permission.new(params[:perm])
		@perm.repository_id = @repo.id
		@perm.save
	
		redirect_to(:controller => :repository, :action => :show, :uid => params[:uid], :id => @repo.name, :protocol => "https://")
	end

	def destroy
		@perm = Permission.find(:first, :conditions => { :id => params[:id] })
		@perm.delete
	
		redirect_to(:controller => :repository, :uid => params[:uid], :id => params[:repository_id], :action => :show, :protocol => "https://")
	end

end
