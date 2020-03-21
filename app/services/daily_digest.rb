class DailyDigest
  def send_digest
    return if Question.created_the_day_before.empty?

    User.find_each do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end
