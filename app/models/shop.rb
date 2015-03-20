class Shop < ActiveRecord::Base
  validates :sift_api_key, :vnda_api_host, :vnda_api_user, :vnda_api_password,
            presence: true
  validates :vnda_api_host, uniqueness: true

  before_create { self.token = SecureRandom.hex }
end
