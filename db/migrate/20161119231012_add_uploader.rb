class AddUploader < ActiveRecord::Migration[4.2]
  def change
    create_table :uploaders do |t|
      t.string :gem_name, :gem_version, null: false
      t.integer :user_id, null: false
      t.timestamp :created_at, null: false
    end

    add_index :uploaders, [:gem_name, :gem_version], length: {gem_name: 30, gem_version: 20}, unique: true
    add_index :uploaders, :user_id
  end
end
