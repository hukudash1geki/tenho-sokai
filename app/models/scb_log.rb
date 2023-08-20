class ScbLog < ApplicationRecord
  validates :scb_daytime, presence: true
  validates :scb_rule, presence: true
  validates :scb_name1, presence: true
  validates :scb_name2, presence: true
  validates :scb_name3, presence: true
  validates :scb_score1, presence: true
  validates :scb_score2, presence: true
  validates :scb_score3, presence: true

  def self.search(search)
    if search.present?
      columns = %w[scb_name1 scb_name2 scb_name3]  # 検索対象のカラム名を指定

      query = self.all
      conditions = columns.map { |col| "#{col} LIKE ?" }.join(' OR ')
      values = ["%#{search}%"] * columns.size

      query.where(conditions, *values)
    else
      puts "no name"
      self.none
    end
  end
end
