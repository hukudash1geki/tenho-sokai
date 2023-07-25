class Tenho_log
  include ActiveModel::Model
  attr_accessor :name, :room, :play_day, :score, :rule, :rank

  with_options presence: true do
    validates :name
    validates :room
    validates :play_day
    validates :score
    validates :rule
    validates :rank
  end
end