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

  def save
    user = User.create(name: name)
    period = Period.create(room: room, play_day: play_day)
    Address.create(score: score, rule: rule, rank: rank, user_id: user.id, period_id: period.id)
  end
end