# == Schema Information
#
# Table name: urls
#
#  id         :bigint           not null, primary key
#  long_url   :string
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Url, type: :model do
  let(:subject) { build(:url) }

  describe 'associations' do
    it { is_expected.to have_many(:visits) }
  end

  describe 'validations' do
    before do
      # We don't want callbacks to run yet
      described_class.any_instance.stub(:set_token).and_return nil
    end

    it { is_expected.to validate_presence_of :long_url }
    it { is_expected.to validate_presence_of :token }
    it { is_expected.to validate_uniqueness_of :token }
    it { is_expected.to validate_url_of :long_url }
  end

  describe 'methods' do
    context '.set_token' do
      it 'is expected to set a value to token' do
        expect(subject.token).to be_nil
        subject.send :set_token
        expect(subject.token).to be_truthy
      end
    end
  end

  describe 'callbacks' do
    context 'create' do
      it 'is expected to call set_token' do
        expect(subject).to receive(:set_token)
        subject.save
      end
    end
  end
end
