
class SiteController < ApplicationController

	def index
		@repos = Repository.find(:all, :conditions => { :hidden => false }, :order => 'updated_at DESC', :limit => 20);
	end
	
end
