class CreateVaProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :va_profiles do |t|
      t.string :niche
      t.string :budget

      t.timestamps
    end
  end
end
