class UserAnswer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  belongs_to :paper
end
