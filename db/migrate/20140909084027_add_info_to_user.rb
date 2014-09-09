class AddInfoToUser < ActiveRecord::Migration
  def change
  	add_column :users, :gender, :string
  	add_column :users, :baby_name, :string
  	add_column :users, :age, :integer
  	add_column :users, :height, :integer
  	add_column :users, :weight, :float
  	add_column :users, :baby_due, :timestamp
  end
end
