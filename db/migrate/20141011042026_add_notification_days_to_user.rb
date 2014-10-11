class AddNotificationDaysToUser < ActiveRecord::Migration
  def change
  	add_column :users, :notifications_days, :string
  	add_column :users, :notificate_at, :time
  end
end
