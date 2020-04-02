class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    DailyDigest.send_digest
  end
end
