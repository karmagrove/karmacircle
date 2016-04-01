class CreateUserInvites < ActiveRecord::Migration
  def change
    create_table :user_invites do |t|
      t.references :user
      t.integer :invitee
      t.boolean :status

      t.timestamps null: false
    end
  end
end
