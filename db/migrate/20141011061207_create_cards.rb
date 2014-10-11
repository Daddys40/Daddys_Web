class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
    	t.integer :user_id, null: false
    	t.string :title
    	t.string :content
    	t.integer :week
    	t.integer :resources_count
      t.timestamps
    end
		add_index(:cards, :week)
    add_index(:cards, :user_id)
  end
end
