require 'rails_helper'

describe DailyDigestJob, type: :job do
  it 'calls DailyDigest#send_digest' do
    expect(DailyDigest).to receive(:send_digest)

    DailyDigestJob.perform_now
  end
end
