
class RepositoryController < ApplicationController
	before_filter :authorize, :only => [ :create, :update, :destroy ]
	
	def index
		if session[:uid] == params[:uid]
			@repos = Repository.find(:all, :conditions => { :owner => params[:uid] })
		else
			@repos = Repository.find(:all, :conditions => { :owner => params[:uid], :hidden => false })
		end
	end
	
	def show
		@repo = Repository.find(:first, :conditions => { :owner => params[:uid], :name => params[:id] })
		@perms = @repo.permissions
		@user = session[:uid]

		render :template => 'site/404', :layout => 'banner' unless @repo
	end
	
	def update
		@repo = Repository.find(:first, :conditions => { :owner => params[:uid], :name => params[:id] })
		@repo.hidden = params[:option] != "null"
		@repo.save
		
		redirect_to(:action => :show, :protocol => "https://")
	end
	
	def create
		@repo = Repository.find(:first, :conditions => { :owner => params[:uid], :name => params[:repo][:name] })
		if @repo then
			flash[:notice] = 'Repository exists'
			redirect_to(:action => :index, :protocol => "https://")
			return
		end
		
		if not /^[a-z][a-z0-9\-]*$/i =~ params[:repo][:name] then
		  redirect_to(:action => :index, :protocol => "https://")
		end
		
		@repo = Repository.new(params[:repo])

		@repo.owner = params[:uid]
		@repo.hidden = true

		if @repo.save
			flash[:notice] = 'Repository created'
			@repo.create!
			redirect_to(:action => :show, :id => @repo.name, :protocol => "https://")
		else
			flash[:notice] = 'Failed to create repository'
			redirect_to(:action => :index, :protocol => "https://")
		end
	end
	
	def destroy
		@repo = Repository.find(:first, :conditions => { :owner => params[:uid], :name => params[:id] })
		@repo.delete!
		
		flash[:notice] = "Repository #{params[:id]} deleted"
		redirect_to(:action => :index, :protocol => "https://")
	end

end
