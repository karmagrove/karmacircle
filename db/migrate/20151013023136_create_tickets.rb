class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.references :event, index: true, foreign_key: true
      t.string :ticket_name
      t.integer :quantity_available
      t.integer :price
      t.string :description
      t.datetime :sales_start
      t.datetime :sales_end
      t.integer :ticket_minimum
      t.integer :ticket_maximum

      t.timestamps null: false
    end
  end
end
