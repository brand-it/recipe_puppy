require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  render_views
  describe 'GET index' do
    context 'html request' do
      subject { get :index }
      it { is_expected.to be_success }
    end
    context 'xhr' do
      subject { get :index, xhr: true }
      it { is_expected.to be_success }
    end
  end
end
