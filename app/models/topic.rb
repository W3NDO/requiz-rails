class Topic < ApplicationRecord
  after_save :createInitialNote

  has_many :subtopics
  has_many :notes
  belongs_to :user

  private
  def createInitialNote
    note = Note.new(topic_id: self.id)
    note.save
  end
end
