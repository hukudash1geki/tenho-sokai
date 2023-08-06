class ScaLog < ApplicationRecord
  validates :room, presence: true
  validates :sca_daytime, presence: true
  validates :sca_rule, presence: true
  validates :sca_name1, presence: true
  validates :sca_name2, presence: true
  validates :sca_name3, presence: true
  validates :sca_score1, presence: true
  validates :sca_score2, presence: true
  validates :sca_score3, presence: true
end
