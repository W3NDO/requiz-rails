class BillingCustomer < ApplicationRecord
  belongs_to :user, required: false
  has_many :billing_subscriptions
end
