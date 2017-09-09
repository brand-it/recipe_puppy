# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipePuppyClient::Search do
  let(:base) { RecipePuppyClient::Search }

  describe '.where' do
    subject do
      VCR.use_cassette 'recipe_puppy/search' do
        RecipePuppyClient::Search.where(query: 'omelet', ingredients: %w[onions garlic], page: 3)
      end
    end

    it { expect(subject.recipes).to be_a(Array) }
    it { expect(subject.recipes[0]['title']).to eq('Vegetable-Pasta Oven Omelet') }
    it { expect(subject.recipes[0]['href']).to eq('http://find.myrecipes.com/recipes/recipefinder.dyn?action=displayRecipe&recipe_id=520763') }
    it do
      expect(subject.recipes[0]['ingredients']).to eq(
        'tomato, onions, red pepper, garlic, olive oil, zucchini, cream cheese, vermicelli, eggs, parmesan cheese'\
        ', milk, italian seasoning, salt, black pepper'
      )
    end
    it { expect(subject.recipes[0]['thumbnail']).to eq('http://img.recipepuppy.com/560556.jpg') }
  end
end
