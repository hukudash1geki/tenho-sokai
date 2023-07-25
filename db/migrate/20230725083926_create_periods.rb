class CreatePeriods < ActiveRecord::Migration[7.0]
  def change
    create_table :periods do |t|
      t.string   :room,                null: false
      t.string   :play_day,            null: false
      t.timestamps
    end
  end
end
