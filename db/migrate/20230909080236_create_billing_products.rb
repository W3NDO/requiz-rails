class CreateBillingProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :billing_products do |t|
      t.string :stripeid, null: false
      t.string :stripeProductName, null: false

      t.timestamps
    end
  end
end
