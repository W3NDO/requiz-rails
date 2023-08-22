class Quiz < ApplicationRecord
require 'csv'
include QuizzesHelper
  after_create_commit :schedule_process_job
  validate :acceptable_file
  
  has_many :questions
  has_many :flashcards
  belongs_to :user
  
  has_one_attached :quiz_file
  enum :processed, [:analyzed, :analyzing], default: :not_analyzed
  enum :processing_status

  def get_questions()
    return self.questions.map{ |q| {:id=> q.id, :question => q.question, :possible_answers => q.possible_answers} }
  end

  def get_tags()
    self.tag.split(",")
  end

  def has_flashcards?
    !self.has_flashcards.nil?
  end

  private
  def acceptable_file
    pp "LOG ==> Success attached" unless quiz_file.attached?
    return unless quiz_file.attached?

    unless quiz_file.blob.byte_size <=1.megabyte
      pp "LOG ==> File too big"
      errors.add(:quiz_file, "is too big")
    end

    acceptable_types = ["text/csv", "text/plain"]
    unless acceptable_types.include?(quiz_file.content_type)
      pp "LOG ==> Unnaceptable file type"
      errors.add(:quiz_file, "must be a .txt file")
    end
  end

  def schedule_process_job
    ScheduleQuizFileProcessingJob.perform_later(self) unless self.analyzed?
  end

end
