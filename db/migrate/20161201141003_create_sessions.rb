class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions, id: :uuid do |t|
      t.datetime :expiry
      t.boolean :on_campus
      t.boolean :is_mobile

      t.timestamps
    end
  end
end
