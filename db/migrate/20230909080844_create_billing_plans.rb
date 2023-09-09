class CreateBillingPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :billing_plans do |t|
      t.belongs_to :billing_product, null: false

      t.string :stripeid, null: false
      t.string :stripe_plan_name
      t.decimal :amount, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
