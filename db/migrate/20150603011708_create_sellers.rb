class CreateSellers < ActiveRecord::Migration
  def change
    create_table :sellers do |t|
      t.string :name
      t.text :description
      t.string :url
      t.string :stripe_id
      t.string :email
      t.string :city
      t.string :state
      t.string :password

      t.timestamps null: false
    end
  end
end
