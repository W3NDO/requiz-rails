class Quiz < ApplicationRecord
require 'csv'
include QuizzesHelper
  # after_create_commit :schedule_process_job
  validate :acceptable_file
  validates :title, presence: true
  validates :tag, presence: true
  validates :quiz_file, presence: true
  
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

  def has_questions?
    !(self.questions.empty? || self.questions.nil?)
  end

  private
  def acceptable_file
    return unless quiz_file.attached?
    acceptable_types = ["text/plain"]
    acceptable_file_extensions = [".pdf", ".txt"]

    unless quiz_file.blob.byte_size <=3.megabyte
      pp "LOG ==> File too big"
      errors.add(:quiz_file, "is too big. Please upload files smaller than 3MB")
    end

    unless acceptable_file_extensions.include?( quiz_file.blob.filename.extension_with_delimiter )
      pp "LOG ==> Unnaceptable file type"
      errors.add(:quiz_file, "must be a .txt or a .pdf file")
    end

    # unless acceptable_types.include?(quiz_file.content_type)
    #   pp "LOG ==> Unnaceptable file type"
    #   errors.add(:quiz_file, "must be a .txt or a .pdf file")
    # end
  end

  def schedule_process_job
    ScheduleQuizFileProcessingJob.perform_later(self) unless self.analyzed?
  end

end
