class DailyDigestJob < ApplicationJob
  # queue_as :default
  queue_as :mailers

  def perform
    DailyDigest.new.send_digest
  end
end
