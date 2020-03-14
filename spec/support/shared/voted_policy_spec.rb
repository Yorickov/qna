require 'rails_helper'

shared_examples 'VotedPolicy' do
  let(:votable_name) { described_class.to_s.split('Policy').first.underscore }
  let(:votable) { create(votable_name.to_sym) }

  subject { described_class.new(user, votable) }

  context 'for Guest' do
    let(:user) { nil }

    it { should forbid_actions(%i[vote_up vote_down vote_reset]) }
  end

  context 'for User and Admin' do
    context 'when author' do
      let(:user) { create(:user) }
      let(:votable) { create(votable_name.to_sym, user: user) }

      it { should forbid_actions(%i[vote_up vote_down vote_reset]) }
    end

    context 'when not author' do
      let(:user) { create(:user) }

      it { should permit_actions(%i[vote_up vote_down vote_reset]) }
    end
  end
end
