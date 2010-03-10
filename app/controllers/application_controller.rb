# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  def error
    render :template => "site/404", :layout => "banner", :status => "404"
  end

	private
		def authorize
			unless session[:uid] and session[:uid] == params[:uid]
				flash[:notice] = 'Permission denied'

				begin
					redirect_to :back
				rescue ActionController::RedirectBackError
					redirect_to root_path
				end
			end
		end
end
