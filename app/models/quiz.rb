class Quiz < ApplicationRecord
require 'csv'
include QuizzesHelper
  after_save :schedule_process_job
  validate :acceptable_file
  has_many :questions
  belongs_to :user
  has_one_attached :quiz_file
  enum :processed, [:analyzed], default: :not_analyzed

  def get_questions()
    return self.questions.map{ |q| {:id=> q.id, :question => q.question, :possible_answers => q.possible_answers} }
  end

  private
  def acceptable_file
    pp "LOG ==> Success attached" unless quiz_file.attached?
    return unless quiz_file.attached?

    unless quiz_file.blob.byte_size <=1.megabyte
      pp "LOG ==> File too big"
      errors.add(:quiz_file, "is too big")
    end

    acceptable_types = ["text/csv"]
    unless acceptable_types.include?(quiz_file.content_type)
      pp "LOG ==> Unnaceptable file type"
      errors.add(:quiz_file, "must be a .csv file")
    end
  end

  def schedule_process_job
    ScheduleQuizFileProcessingJob.perform_later(self) unless self.analyzed?
  end

end
