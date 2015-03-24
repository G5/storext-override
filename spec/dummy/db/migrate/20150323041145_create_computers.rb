class CreateComputers < ActiveRecord::Migration
  def change
    create_table :computers do |t|
      t.text :data
      t.timestamps
    end
  end
end
