# == Schema Information
#
# Table name: visits
#
#  id         :bigint           not null, primary key
#  ip_address :string
#  url_id     :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Visit, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:url) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ip_address) }
  end
end
