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
  validates :gender, inclusion: GENDER.values
  validates :baby_name, presence: true, length: { :minimum => 1, :maximum => 128 }
  validates :age, presence: true
  validates :height, presence: true
  validates :weight, presence: true
  validates :baby_due, presence: true

  validates :authentication_token, presence: true

  before_validation :ensure_authentication_token, on: :create

  def public_hash
    ## TODO : remove private data that shoud not be exposed on client side
    return JSON.parse(self.to_json)
  end

  def generate_invitation_code
    begin
      self.invitation_code = Digest::SHA1.hexdigest([Time.now, rand].join)[0,4].upcase
    end while User.find_by_invitation_code(self.invitation_code)
  end

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
