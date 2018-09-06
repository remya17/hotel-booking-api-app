class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, limit: 200
      t.string :first_name, null: false, limit: 200
      t.string :last_name, null: false, limit: 200

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
