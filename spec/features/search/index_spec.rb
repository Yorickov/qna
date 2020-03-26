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

    scenario 'in separate resources' do
      mapping = {
        t('helpers.question') => [[question1, question2], question3],
        t('helpers.answer') => [[answer1, answer2], answer3],
        t('helpers.comment') => [[comment1, comment2], comment3]
      }

      mapping.each do |resource_name, resources|
        ThinkingSphinx::Test.run do
          search_in('correct', resource_name)

          resources.first.each { |resource| expect(page).to have_content(resource.body) }
          expect(page).not_to have_content(resources.last.body)
        end
      end
    end
  end

  describe 'Resource search failed', sphinx: true do
    background { visit questions_path }

    scenario 'when finding nothing' do
      [t('helpers.question'), t('helpers.answer'), t('helpers.comment')].each do |resource|
        ThinkingSphinx::Test.run do
          search_in('yoda', resource)

          expect(page).to have_content(t('search.index.empty_result'))
        end
      end
    end

    scenario 'when query is empty' do
      [t('helpers.question'), t('helpers.answer'), t('helpers.comment')].each do |resource|
        ThinkingSphinx::Test.run do
          search_in('  ', resource)

          expect(page).to have_content(t('search.index.empty_query'))
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

        expect(page).to have_content(t('search.index.empty_result'))
      end
    end

    scenario 'has empty query' do
      ThinkingSphinx::Test.run do
        search_in('   ')

        expect(page).to have_content(t('search.index.empty_query'))
      end
    end
  end
end
