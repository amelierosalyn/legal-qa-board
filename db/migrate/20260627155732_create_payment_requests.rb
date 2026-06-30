class CreatePaymentRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :payment_requests do |t|
      t.references :answer, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
