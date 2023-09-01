class ScbLog < ApplicationRecord
  validates :scb_daytime, presence: true
  validates :scb_rule, presence: true
  validates :scb_name1, presence: true
  validates :scb_name2, presence: true
  validates :scb_name3, presence: true
  validates :scb_score1, presence: true
  validates :scb_score2, presence: true
  validates :scb_score3, presence: true

  def self.search_user(username)
    if username.present?
      query = self.where(
        "scb_name1 LIKE :search OR scb_name2 LIKE :search OR scb_name3 LIKE :search OR scb_name4 LIKE :search",
        search: "%#{username}%"
      )
      query
    else
      puts "no username"
      self.none
    end
  end
end
