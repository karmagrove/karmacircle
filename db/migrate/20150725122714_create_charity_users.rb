class CreateCharityUsers < ActiveRecord::Migration
  def change
    create_table :charity_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :charity, index: true, foreign_key: true
      t.integer :role

      t.timestamps null: false
    end
  end
end
