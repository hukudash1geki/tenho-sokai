class ScbLog < ApplicationRecord
  validates :scb_daytime, presence: true
  validates :scb_rule, presence: true
  validates :scb_name1, presence: true
  validates :scb_name2, presence: true
  validates :scb_name3, presence: true
  validates :scb_score1, presence: true
  validates :scb_score2, presence: true
  validates :scb_score3, presence: true
end
