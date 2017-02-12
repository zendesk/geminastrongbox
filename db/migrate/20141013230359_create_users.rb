class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :external_id
      t.string :name
      t.string :email
      t.boolean :is_admin

      t.timestamps

      t.index :external_id, :unique => true
    end
  end
end
