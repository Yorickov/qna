class NotificationJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    Notification.notify(answer)
  end
end
