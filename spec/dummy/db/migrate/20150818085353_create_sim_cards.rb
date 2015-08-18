class CreateSimCards < ActiveRecord::Migration
  def change
    create_table :sim_cards do |t|
      t.text :data
      t.references :phone
      t.timestamps
    end
  end
end
