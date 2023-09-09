class SynchronizeBillingPlans
  def call
    # Gather existing plans
    existing_plans_by_stripeid = BillingPlan.all.each_with_object({}) do |plan, acc|
      acc[plan.stripeid] = plan
    end

    # Track plans we have confirmed exist on Stripe's end
    confirmed_existing_stripeids = []

    # Fetch all of our active plans from Stripe
    Stripe::Plan.list( { active: true})["data"].each do |plan|
      # If we know the plan exists, we just update the non static fields on our end
      if existing_plans_by_stripeid[plan["id"]].present?
        existing_plans_by_stripeid[plan["id"]].update!({
          stripe_plan_name: plan["nickname"],
          amount: plan["amount"]
        })
      else
        # if we're not aware of the plan, we create a new one.
        BillingPlan.create!({
          billing_product: BillingProduct.find_by({ stripeid: plan["product"] }),
          stripeid: plan["id"],
          stripe_plan_name: plan["nickname"],
          amount: plan["amount"],
        })
      end

      confirmed_existing_stripeids << plan["id"]
    end

    # Delete any plans on our end that no longer exist
    BillingPlan.where.not({
      stripeid: confirmed_existing_stripeids
    }).destroy_all

    nil
  end
end