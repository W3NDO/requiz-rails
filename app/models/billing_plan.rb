class BillingPlan < ApplicationRecord
  belongs_to :billing_product
  has_many :billing_subscriptions
end
