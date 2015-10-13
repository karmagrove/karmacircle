class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :description
      t.string :name
      t.integer :price
      t.boolean :public
      t.integer :donation_percent
      t.string :image_url
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
