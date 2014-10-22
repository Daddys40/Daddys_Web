class ChangeTextColumnToText < ActiveRecord::Migration
	def up
    change_column :cards, :title, :text
    change_column :cards, :content, :text
	end
	def down
    change_column :cards, :title, :string
    change_column :cards, :content, :string
	end
end
