class TenhoLog
  include ActiveModel::Model
  attr_accessor :name, :room, :play_day, :score, :rule, :rank

  def save
    user = User.create(name: name)
    period = Period.create(room: room, play_day: play_day)
    result = Result.create(score: score, rule: rule, rank: rank, user_id: user.id, period_id: period.id)
  end
end