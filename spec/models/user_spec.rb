require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do 
    @user1 = create(:user)
  end

  it "creates a new user" do
    expect(@user1).to be_valid
    expect(@user1.persisted?).to be true
  end

  it "fails to create an invalid user" do
    user2 = build(:user, email: "email2@example.com", password: "foobar123", password_confirmation: "foobaz123")
    expect( user2).to_not be_valid
  end

  it "ensures that a user has a public ID" do
    expect(@user1.public_id).to_not be_nil
  end
end
