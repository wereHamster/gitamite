
class Permission < ActiveRecord::Base
	has_one :repository
	
	validates_presence_of :uid, :refex
	
	def authorized(uid, ref, access)
		return true if repository.owner == uid
		ref.match(refex) and access >= level
	end
end
