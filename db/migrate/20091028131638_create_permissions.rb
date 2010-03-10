
class CreatePermissions < ActiveRecord::Migration
	def self.up
		create_table :permissions do |t|
			t.timestamps

			t.references :repository
			
			t.string :uid, :refex
			t.integer :level
		end
	end

	def self.down
		drop_table :permissions
	end
end
