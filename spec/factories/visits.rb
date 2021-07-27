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
FactoryBot.define do
  factory :visit do
    ip_address { FFaker::Internet.ip_v4_address }
    url
  end
end
