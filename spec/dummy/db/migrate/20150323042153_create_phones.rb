class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.text :data
      t.references :computer
      t.timestamps
    end
  end
end
