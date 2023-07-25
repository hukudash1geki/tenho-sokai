class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :results do |t|
      t.string     :score,                null: false
      t.string     :rule,                 null: false
      t.integer    :rank,                 null: false
      t.references :user,                 null: false, foreign_key: true
      t.references :period,               null: false, foreign_key: true
      t.timestamps
    end
  end
end
