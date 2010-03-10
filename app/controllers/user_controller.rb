
class UserController < ApplicationController

	def index
		@repos = Repository.find(:all, :conditions => { :owner => params[:uid] })
	end

end
