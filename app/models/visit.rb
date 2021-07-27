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

class Visit < ApplicationRecord
  belongs_to :url, counter_cache: :visits_count

  validates :ip_address, presence: true

  default_scope { order(created_at: :desc) }
end
