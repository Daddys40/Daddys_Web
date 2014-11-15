class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      ## Trackable
      t.references  :user, null: false
      t.text :text
      t.boolean :checked

      t.timestamps
    end
  end
end
