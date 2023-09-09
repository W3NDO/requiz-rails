class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  before_save :generatePublicId

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validates :password, length: {minimum: 6}
  has_many :topics
  has_many :quizzes
  has_many :billing_customers

  enum role: {admin: 0, student: 1}

  def has_quizzes?
    return !(self.quizzes.empty?)
  end

  def has_processed_quizzes?
    return !(self.quizzes.analyzed.empty?)
  end

  def processed_quizzes
    self.quizzes.analyzed
  end

  private
  def generatePublicId
    publicId = SecureRandom.hex(3)
    self.public_id = publicId
  end

end
