class CreateCharities < ActiveRecord::Migration
  def change
    create_table :charities do |t|
      t.string :name
      t.text :description
      t.string :url
      t.string :stripe_id
      t.string :email
      t.string :city
      t.string :state

      t.timestamps null: false
    end
  end
end
