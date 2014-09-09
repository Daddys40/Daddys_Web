class User < ActiveRecord::Base
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

	GENDER = Hashie::Mash.new({
           	 MALE: "male",
           	 FEMALE: "female",
           }).freeze

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # TODO FIX 
  # validates :gender, inclusion: GENDER.values
  # validates :baby_name, presence: true, length: { :minimum => 1, :maximum => 128 }
  # validates :age, presence: true
  # validates :height, presence: true
  # validates :weight, presence: true
  # validates :baby_due, presence: true

  # validates :authentication_token, presence: true

  before_create :ensure_authentication_token

  private

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.find_by_authentication_token(token)
    end
  end
end
