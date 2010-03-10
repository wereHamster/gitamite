
class CreateRepositories < ActiveRecord::Migration
	def self.up
		create_table :repositories do |t|
			t.timestamps

			t.string :owner, :name, :description
			t.boolean :hidden
		end
	end

	def self.down
		drop_table :repositories
	end
end
