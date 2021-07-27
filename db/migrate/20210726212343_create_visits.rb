class CreateVisits < ActiveRecord::Migration[6.1]
  def change
    create_table :visits do |t|
      t.string :ip_address
      t.references :url, foreign_key: true, null: false

      t.timestamps
    end
  end
end
