
module ApplicationHelper
		
	def logged_in?
		session[:uid] != nil
	end

	def current_user_name
		session[:uid]
	end
end
