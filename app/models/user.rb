class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum role: [:admin, :student]
  has_many :user_answers, :through => :papers, foreign_key: :user_id
  has_and_belongs_to_many :papers
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  scope :active_users, -> {where(is_block: true)}

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      # active_users.where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      active_users.where(["lower(username) = :value OR lower(email) = :value OR phone_number = :value" , { :value => login.downcase }]).where.not(role: [nil, 'user']).first
    elsif conditions.has_key?(:phone_number)
      active_users.where(["phone_number = :value", { :value => conditions[:phone_number] }]).where.not(role: [nil, 'user']).first
    elsif email = conditions.delete(:email)
      active_users.where(["lower(email) = :value", { :value => email.downcase }]).first
    elsif conditions.has_key?(:username)
      active_users.where.not(role:'user').first
    end
  end

end
