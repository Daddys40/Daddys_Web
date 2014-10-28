class AddReadedToCard < ActiveRecord::Migration
  def change
		add_column :cards, :readed, :boolean, default: false
  end
end
