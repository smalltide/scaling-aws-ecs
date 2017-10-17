class CreateJavelins < ActiveRecord::Migration
  def change
    create_table :javelins do |t|
      t.integer :thrown

      t.timestamps null: false
    end
  end
end
