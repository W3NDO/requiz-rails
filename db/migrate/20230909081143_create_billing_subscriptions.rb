class CreateBillingSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :billing_subscriptions do |t|
      t.belongs_to :billing_plan, null: false
      t.belongs_to :billing_customer, null: false
      
      t.string :stripeid, null: false
      t.string :status, null: false
      
      t.datetime :current_period_end
      t.datetime :cancel_at

      t.timestamps
    end
  end
end
