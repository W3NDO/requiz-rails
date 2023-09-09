class CreateBillingCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :billing_customers do |t|
      t.references :user

      t.string :stripeid, null: false
      t.string :default_source

      t.timestamps
    end
  end
end
