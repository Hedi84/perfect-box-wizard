class CreateOnboardings < ActiveRecord::Migration[8.1]
  def change
    create_table :onboardings do |t|
      t.references :user, null: false, foreign_key: true

      # Personal details
      t.string :first_name
      t.string :last_name

      # Address
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :postcode

      # Preferences
      t.json :dietary_preferences, null: false, default: []

      # Wizard state
      t.string :current_step, null: false, default: "personal"
      t.datetime :completed_at

      t.timestamps
    end

    add_index :onboardings, :completed_at
    add_index :onboardings, :current_step
  end
end
