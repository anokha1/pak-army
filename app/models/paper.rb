class Paper < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :questions
  has_many :user_answers, :through => :questions, foreign_key: :paper_id
  accepts_nested_attributes_for :questions
end
