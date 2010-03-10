
class Repository < ActiveRecord::Base
	has_many :permissions
	
	validates_presence_of :owner, :name
	
	def authorized(uid, access)
		return true if owner == uid
		
		begin
			perms = permissions.find(:all, :conditions => { :repository_id => self, :uid => uid })
		rescue ActiveRecord::RecordNotFound
			return !hidden
		end
		
		if perms and perms.length > 0
			access > 0
		else
			not hidden
		end
	end
	
	def create!
		return true if File.exist?(full_path)
		
		FileUtils.mkdir_p(full_path)
		FileUtils.chmod(0777, File.join(Rails.root, 'repos', owner))

		repo = Grit::Repo.init_bare(full_path, { 'shared' => '0666' })
		
		src = File.join("#{RAILS_ROOT}/data/hooks/update")
		FileUtils.ln_sf(src, File.join(full_path, 'hooks', "update"))
		
		true
	end
	
	def delete!
		FileUtils.rm_rf(full_path)
		delete
	end
	
	def full_path
		File.join(Rails.root, 'repos', owner, name + '.git')
	end
	
	def history
		begin
			repo = Grit::Repo.new(full_path)
		rescue Object => e
			return
		end
		repo.commits('master', 20)
	end
	
	def rel_date(date)
	  date = Date.parse(date, true) unless /Date.*/ =~ date.class.to_s
	  days = (date - Date.today).to_i

	  return 'today'     if days >= 0 and days < 1
	  return 'tomorrow'  if days >= 1 and days < 2
	  return 'yesterday' if days >= -1 and days < 0

	  return "in #{days} days"      if days.abs < 60 and days > 0
	  return "#{days.abs} days ago" if days.abs < 60 and days < 0

	  return date.strftime('%A, %B %e') if days.abs < 182
	  return date.strftime('%A, %B %e, %Y')
	end
end
