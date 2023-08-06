class CreateScaLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :sca_logs do |t|
      t.string :room,             null: false
      t.datetime :sca_daytime,      null: false
      t.string :sca_rule,         null: false
      t.string :sca_name1,        null: false
      t.string :sca_name2,        null: false
      t.string :sca_name3,        null: false
      t.string :sca_name4
      t.string :sca_score1,       null: false
      t.string :sca_score2,       null: false
      t.string :sca_score3,       null: false
      t.string :sca_score4
      t.timestamps
    end
  end
end
