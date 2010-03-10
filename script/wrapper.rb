#!/usr/bin/env ruby

require "yaml"
require "shellwords"

# Logins of users who are allowed to get shell access
admins = [ 'root' ]


ENV["RAILS_ENV"] ||= "production"
require File.dirname(__FILE__) + '/../config/boot'

File.umask(0022)

# Check if the user wants to access the shell or git repositories,
# only selected users can execute arbitrary commands
ssh_original_command = ENV["SSH_ORIGINAL_COMMAND"]

if not ssh_original_command or
   not ssh_original_command.match(/^git[ -]upload-pack|^git[ -]receive-pack/)
	unless admins.include?(ENV['USER']) then
		$stderr.puts "What do you think I am? A shell?"
		exit(0)
	end
	
	cmd = ssh_original_command || ENV['SHELL'] || "/bin/sh"
	exec("#{cmd}")
	
	$stderr.puts "Uh oh, could not exec shell"
	exit(1)
end

begin
	args = Shellwords.shellwords(ssh_original_command)
	if args.length != 2
		$stderr.puts "Malformed git command: #{ssh_original_command}"
		exit(1)
	end
	
	path = args[1].split('/')
	if path.length != 2 or not path[1].match(/\.git$/)
		$stderr.puts "Malformed repository path #{args[1].inspect}"
		exit(1)
	end
		
	repo = Repository.find(:first, :conditions => { :owner => path[0], :name => path[1].chomp('.git') })
	if repo and repo.authorized(ENV['USER'], 1) and repo.create!		
		repo_root = File.join(Rails.root, 'repos')
		Dir.chdir(repo_root)
		
		cmd = "#{args[0]} '#{repo.full_path}'"
		exec('git-shell', '-c', cmd)
	end
rescue ActiveRecord::RecordNotFound => e
	$stderr.puts "Repository not found"
	exit(0)
rescue Object => e
	$stderr.puts("#{e.class.name} #{e.message}: #{e.backtrace.join("\n  ")}")
	exit(1)
end
