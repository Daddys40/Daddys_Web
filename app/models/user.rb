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

  has_many :cards, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :partner_invitation_code

  has_one :partner, class_name: User.to_s, foreign_key: "partner_id"

  # TODO FIX 
  # validates :gender, inclusion: GENDER.values
  # validates :baby_name, presence: true, length: { :minimum => 1, :maximum => 128 }
  # validates :age, presence: true  
  # validates :height, presence: true
  # validates :weight, presence: true
  # validates :baby_due, presence: true

  validates :authentication_token, presence: true
  validates :notifications_days, presence: true, length: { is: 3 }, format: { with: /\A[0-9]+\z/,
    message: "only allows numbers" }

  # before_create :create_with_invitation_code, if: lambda { |user| user.partner_invitation_code }
  before_validation :ensure_authentication_token, on: :create
  before_validation :check_invitation_code, on: :create, if: lambda { |user| user.partner_invitation_code }

  after_create :set_opponent_partner, #, if: "partner_id_changed?"

  def generate_invitation_code
    begin
      self.invitation_code = Digest::SHA1.hexdigest([Time.now, rand].join)[0,4].upcase
    end while User.find_by_invitation_code(self.invitation_code)
  end

  private

  def check_invitation_code  
    partner = User.find_by_invitation_code(self.partner_invitation_code)
    if partner
      self.partner_id = partner.id
    else
      self.errors.add(:partner_invitation_code, "It's invalid invitation code")
    end
  end

  def set_opponent_partner
    if partner_id 
      User.find_by_id(partner_id).update_attribute(:partner_id, self.id)
    end
  end

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
