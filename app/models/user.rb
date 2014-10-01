class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  
  before_save { email.downcase! }
  before_create :create_remember_token
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\Z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :email, uniqueness: { case_sensitive: false } 
  validates :password, length: { minimum: 6 }
  has_secure_password
  
  def feed
    microposts
  end
  
  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  private
    
    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
