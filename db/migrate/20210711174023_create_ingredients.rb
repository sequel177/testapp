class CreateIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :ingredients do |t|
      t.references :drink, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
