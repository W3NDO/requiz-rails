require 'rails_helper'

RSpec.describe User, type: :model do
  # before(:all) do 
  #   @user1 = create(:user)
  # end

  context "User is created and persisted successfully" do
    let(:user1){ create(:user) }
    
    it "creates a new user" do
      # user1.save
      expect(user1).to be_valid
      expect(user1.persisted?).to be true
    end

    it "ensures that a user has a public ID" do
      expect(user1.public_id).to_not be_nil
    end

    xit "has quizzes" do
      # TODO add a line here to create the quizzes
      expect(user1.has_quizzes? ).to be true
    end
    
    xit "has processed quizzes" do
      # TODO add a line here to create a processed quiz
      expect(user1.has_processed_quizzes?).to be true
    end
    
    xit "has no quizzes" do
      # TODO
    end
  
    xit "has no processed quizzes"
  
    xit "#processed_quizzes function returns an array of processed quizzes"

  end

  context "User is not persisted successfully" do
    it "fails to create an invalid user" do
      user2 = build(:user, email: "email2@example.com", password: "foobar123", password_confirmation: "foobaz123")
      expect( user2).to_not be_valid
    end
  end
end
