class AddInvitationCodeToUser < ActiveRecord::Migration
  def change
  	add_column :users, :invitation_code, :string
	add_column :users, :partner_id, :integer

	add_index :users, :invitation_code
  end
end
