require 'rails_helper'

shared_examples 'votable' do
  describe 'Association' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe 'Methods' do
    let(:model) { described_class }
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:votable) { create(model.to_s.underscore.to_sym, user: user2) }

    it 'vote_up!' do
      votable.vote_up!(user1)

      expect(votable.rating).to eq 1
      expect(votable.votes.first.value).to eq 1
    end

    it 'vote_down!' do
      votable.vote_down!(user1)

      expect(votable.rating).to eq(-1)
      expect(votable.votes.first.value).to eq(-1)
    end

    it 'voted?' do
      votable.vote_up!(user1)
      expect(votable.rating).to eq 1

      votable.vote_up!(user1)
      expect(votable.rating).to eq 1

      votable.vote_down!(user1)
      expect(votable.rating).to eq 1
    end

    it 'votable_author' do
      votable.vote_up!(user2)
      expect(votable.rating).to eq 0
    end

    it 'vote_reset!' do
      votable.vote_up!(user1)
      expect(votable.rating).to eq 1
      expect(Vote.count).to eq 1

      votable.vote_reset!(user1)
      expect(votable.rating).to eq 0
      expect(Vote.count).to eq 0

      votable.vote_down!(user1)
      expect(votable.rating).to eq(-1)
      expect(Vote.count).to eq 1

      votable.vote_reset!(user1)
      expect(votable.rating).to eq 0
      expect(Vote.count).to eq 0
    end
  end
end
