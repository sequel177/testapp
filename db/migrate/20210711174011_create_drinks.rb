class CreateDrinks < ActiveRecord::Migration[6.1]
  def change
    create_table :drinks do |t|
      t.string :title
      t.text :description
      t.text :steps
      t.string :source

      t.timestamps
    end
  end
end
