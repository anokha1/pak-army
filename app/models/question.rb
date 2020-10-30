class Question < ApplicationRecord
  belongs_to :paper
  has_one :multiple_choice
  has_one :user_answer
end
