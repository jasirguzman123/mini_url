class CreateUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :urls do |t|
      t.string :long_url
      t.string :token
      t.integer :visits_count, default: 0, null: false

      t.timestamps
    end
  end
end
