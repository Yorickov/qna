class Notification
  def self.notify(answer)
    answer.question.subscribed_users.find_each do |user|
      NotificationMailer.notify(user, answer).deliver_later
    end
  end
end
