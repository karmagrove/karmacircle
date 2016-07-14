class AddSpecialInstructionsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :special_instructions, :boolean
  end
end
