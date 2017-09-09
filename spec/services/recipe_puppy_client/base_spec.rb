# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipePuppyClient::Base do
  let(:base) { RecipePuppyClient::Base }
  let(:access_denied) { spy(response: spy(code: 401)) }
  let(:base_new) { RecipePuppyClient::Base.new }
  let(:record_missing) { spy(response: spy(code: 404)) }
  let(:redirect) { spy(response: spy(code: 302)) }

  describe '#get' do
    context 'happy path' do
      subject do
        VCR.use_cassette 'recipe_puppy/omelet' do
          RecipePuppyClient::Base.get('/', query: { i: 'onions,garlic', q: 'omelet', p: 3 })
        end
      end
      it { expect(subject.class).to eq HTTParty::Response }
      it { expect(subject.response.code.to_i).to eq 200 }
    end
  end

  describe '.verify_response' do
    context '401' do
      subject { base.verify_response(access_denied) }
      it { expect { subject }.to raise_exception RecipePuppyClient::AccessDenied }
    end
    context '404' do
      subject { base.verify_response(record_missing) }
      it { expect { subject }.to raise_exception RecipePuppyClient::NotFound }
    end
    context '302' do
      subject { base.verify_response(redirect) }
      it { expect { subject }.to raise_exception RecipePuppyClient::Redirect }
    end
  end

  describe '.setup' do
    context 'when making a network request' do
      subject! { base.setup }
      it { expect(base.default_options[:base_uri]).to eq RecipePuppyClient.configuration.uri.to_s }
    end
  end

  describe '.headers' do
    context 'defaults that are applyed to all requests' do
      subject { base.headers }
      it { expect(subject['Accept']).to eq 'application/json' }
      it { expect(subject['Content-Type']).to eq 'application/json' }
    end
  end
end
