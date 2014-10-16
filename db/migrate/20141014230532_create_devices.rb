class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.belongs_to :user
      t.string :name
      t.string :identifier
      t.string :password_digest
      t.datetime :used_at
      t.timestamps

      t.index :identifier, :unique => true
    end
  end
end
