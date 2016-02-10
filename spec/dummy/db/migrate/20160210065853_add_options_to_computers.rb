class AddOptionsToComputers < ActiveRecord::Migration
  def change
    add_column :computers, :options, :text
  end
end
