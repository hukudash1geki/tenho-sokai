class CreateScbLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :scb_logs do |t|
      t.datetime :scb_daytime,           null: false
      t.string :scb_rule,              null: false
      t.string :scb_name1,             null: false
      t.string :scb_name2,             null: false
      t.string :scb_name3,             null: false
      t.string :scb_name4
      t.string :scb_score1,            null: false
      t.string :scb_score2,            null: false
      t.string :scb_score3,            null: false
      t.string :scb_score4
      t.timestamps
    end
  end
end
