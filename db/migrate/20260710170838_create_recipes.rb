class CreateRecipes < ActiveRecord::Migration[8.1]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.json :tags, null: false, default: []

      t.timestamps
    end
  end
end
