class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum role: [:admin, :user, :atm, :gift_card, :merchant, :app, :qc, :iso, :partner, :agent, :affiliate, :support, :support_mtrac, :employee, :support_customer, :admin_user, :affiliate_program]
  has_many :user_answers, :through => :papers, foreign_key: :user_id
  has_and_belongs_to_many :papers
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
