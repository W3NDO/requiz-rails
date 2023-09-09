class SynchronizeBillingProducts
  def call
    # Gather existing product
    existing_products_by_stripeid = BillingProduct.all.each_with_object({}) do |product, acc|
      acc[product.stripeid] = product
    end

    # track the products that have been confirmed.
    confirmed_existing_stripeids = []

    # Fetch all active products from Stripe
    Stripe::Product.list({ active: true })["data"].each do |product|
      # If we are already aware of the product, update the non-static fields on our end
      if existing_products_by_stripeid[product["id"]].present?
        existing_products_by_stripeid[product["id"]].update!({ stripeProductName: product["name"] })
      
      #  if we're not aware of the product, we create it on our end
      else
        BillingProduct.create!({
          stripeid: product["id"],
          stripeProductName: product["name"]
        })
      end

      confirmed_existing_stripeids << product["id"]
    end

    # Finally, delete any products that no longer exist (or are not active) on Stripe
    BillingProduct.where.not({
      stripeid: confirmed_existing_stripeids
    }).destroy_all

    nil
  end
end