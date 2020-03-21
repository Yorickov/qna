class Notification
  def self.notify(answer)
    subscribed_users = answer.question.subscribed_users
    return if subscribed_users.empty?

    subscribed_users.find_each do |user|
      NotificationMailer.notify(user, answer).deliver_later
    end
  end
end
