class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    DailyDigest.send_digest
  end
end
