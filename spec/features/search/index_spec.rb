require 'sphinx_helper'

feature 'Guest can use search on the site' do
  given!(:question1) { create(:question, body: 'correct q one') }
  given!(:question2) { create(:question, body: 'correct q two') }
  given!(:question3) { create(:question, body: 'another q three') }

  given!(:answer1) { create(:answer, body: 'correct a one') }
  given!(:answer2) { create(:answer, body: 'correct a two') }
  given!(:answer3) { create(:answer, body: 'another a three') }

  given!(:comment1) { create(:comment, commentable: question1, body: 'correct c one') }
  given!(:comment2) { create(:comment, commentable: question2, body: 'correct c two') }
  given!(:comment3) { create(:comment, commentable: answer2, body: 'another c three') }

  describe 'Resource search completes successfully', sphinx: true do
    background { visit questions_path }

    scenario 'in questions' do
      ThinkingSphinx::Test.run do
        search_in('correct', 'question')

        [question1, question2]
          .each { |question| expect(page).to have_content(question.body) }
        expect(page).not_to have_content(question3.body)
      end
    end

    scenario 'in answers' do
      ThinkingSphinx::Test.run do
        search_in('correct', 'answer')

        [answer1, answer2]
          .each { |answer| expect(page).to have_content(answer.body) }
        expect(page).not_to have_content(answer3.body)
      end
    end

    scenario 'in comments' do
      ThinkingSphinx::Test.run do
        search_in('correct', 'comment')

        [comment1, comment2]
          .each { |comment| expect(page).to have_content(comment.body) }
        expect(page).not_to have_content(comment3.body)
      end
    end
  end

  describe 'Resource search full - empty', sphinx: true do
    background { visit questions_path }

    scenario 'Resource search has found nothing' do
      %w[question answer comment].each do |resource|
        ThinkingSphinx::Test.run do
          search_in('yoda', resource)

          expect(page).not_to have_content('yoda')
          expect(page).to have_content('Nothing has been found')
        end
      end
    end

    scenario 'Resource search has found averything (empty query)' do
      %w[question answer comment].each do |resource|
        ThinkingSphinx::Test.run do
          search_in('', resource)

          %w[one two three]
            .each { |body| expect(page).to have_content(body) }
        end
      end
    end
  end

  describe 'Global search', sphinx: true do
    background { visit questions_path }

    scenario 'completes successfully' do
      ThinkingSphinx::Test.run do
        search_in('another')

        [question3, answer3, comment3]
          .each { |resource| expect(page).to have_content(resource.body) }

        [question1, answer1, comment1]
          .each { |resource| expect(page).not_to have_content(resource.body) }
      end
    end

    scenario 'has found nothing' do
      ThinkingSphinx::Test.run do
        search_in('yoda')

        expect(page).not_to have_content('yoda')
        expect(page).to have_content('Nothing has been found')
      end
    end

    scenario 'has found everything (empty query)' do
      ThinkingSphinx::Test.run do
        search_in('')

        [question1, question2, question3, answer1, answer2, answer3, comment1, comment2, comment3]
          .each { |resource| expect(page).to have_content(resource.body) }
      end
    end
  end
end
