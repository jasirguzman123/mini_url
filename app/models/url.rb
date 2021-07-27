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

class Url < ApplicationRecord
  TOKEN_LENGTH = 4

  has_many :visits, dependent: :destroy

  validates :long_url, :token, presence: true
  validates :token, uniqueness: true
  validates :long_url, url: true

  before_validation :set_token, on: :create

  private

  def set_token
    loop do
      self.token = SecureRandom.hex(TOKEN_LENGTH)

      break unless Url.exists? token: token
    end
  end
end
