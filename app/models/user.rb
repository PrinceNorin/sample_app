class User < ActiveRecord::Base
  attr_accessor :activation_token
  
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: :follower_id, dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reversed_relationships, foreign_key: :followed_id,
           class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :reversed_relationships, source: :follower
  
  before_save { email.downcase! }
  before_create :create_remember_token
  before_create :create_activation_digest
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\Z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :email, uniqueness: { case_sensitive: false } 
  validates :password, length: { minimum: 6 }
  has_secure_password
  
  def feed
    Micropost.from_users_followed_by(self)
  end
  
  def following?(other_user)
    relationships.find_by followed_id: other_user.id
  end
  
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  
  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end
  
  def has_activation_token?(token)
    self.activation_digest == User.digest(token)
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
    
    def create_activation_digest
      self.activation_token = User.new_remember_token
      self.activation_digest = User.digest(activation_token)
    end
end
