class NotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Notification.notify(answer)
  end
end
