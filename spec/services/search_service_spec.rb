require 'rails_helper'

describe SearchService do
  context 'with resource' do
    it 'search in one resource' do
      %w[question answer comment user].each do |resource|
        search_params = { q: 'myContent', resource: resource }
        resource_klass = resource.classify.constantize

        expect(resource_klass)
          .to receive(:search)
          .with(search_params[:q])
          .and_call_original

        SearchService.call(search_params)
      end
    end
  end

  context 'without resource' do
    let(:search_params) { { q: 'myContent', resource: 'all' } }

    it 'search in all resources' do
      expect(ThinkingSphinx).to receive(:search).with(search_params[:q]).and_call_original

      SearchService.call(search_params)
    end
  end
end
