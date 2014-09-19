class User < ActiveRecord::Base
  before_save :down_case_email
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\Z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :email, uniqueness: true
  
  private
    def down_case_email
      self.email = email.downcase
    end
end
