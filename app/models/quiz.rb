class Quiz < ApplicationRecord
include QuizzesHelper
  after_save :process_file
  validate :acceptable_file
  has_many :questions
  belongs_to :user
  has_one_attached :quiz_file


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

  def process_file
    # process_input_file(self.quiz_file, self)
    self.quiz_file.open do |file|
      file.each_line do |line|
        line = line.split(',')
        q = Question.new()
        q.question = line[0]
        q.answer = line[-1]
        q.possible_answers = line[1..-2]
        q.quiz_id = self.id
        q.tag = self.tag
        if q.valid?
          q.save
        end
      end
    end
  end

end
