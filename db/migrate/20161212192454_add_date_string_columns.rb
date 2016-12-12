class AddDateStringColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :created_at_string, :string
    add_column :sessions, :created_at_string, :string
    add_column :searches, :created_at_string, :string

    add_index :events, :created_at_string
    add_index :sessions, :created_at_string
    add_index :searches, :created_at_string
  end
end
