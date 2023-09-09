module Stripe
  require 'pry'
  class CreateStripeBillingCustomer
    def call(user:, stripe_token: nil)
      #  fetch all users wih the same email
      existing_customers_with_email = Stripe::Customer.list({email: user.email})["data"]
      
      # If we've found any matching customers for the user, grab it
      if existing_customers_with_email.size.positive?
        stripe_customer = existing_customers_with_email.first
      else
        # Otherwise, create a new customer for the user
        stripe_customer = Stripe::Customer.create({
          name: user.full_name,
          email: user.email,
          source: stripe_token,
        })
      end
      # Ensure we persist the customer on our end.
      BillingCustomer.create!({
        user_id: user.id,
        stripeid: stripe_customer.id,
        default_source: stripe_customer.default_source,
      })
    end
  end
end