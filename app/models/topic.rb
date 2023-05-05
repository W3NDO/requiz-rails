class Topic < ApplicationRecord
  has_many :subtopics
  belongs_to :user
end
