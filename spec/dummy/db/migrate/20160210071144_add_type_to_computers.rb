class AddTypeToComputers < ActiveRecord::Migration
  def change
    add_column :computers, :type, :text
  end
end
