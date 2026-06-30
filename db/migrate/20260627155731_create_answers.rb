class CreateAnswers < ActiveRecord::Migration[8.1]
  def change
    create_table :answers do |t|
      t.references :question, null: false, foreign_key: true
      t.references :lawyer, null: false, foreign_key: { to_table: :users }
      t.text :response_text
      t.integer :proposed_fee_pence
      t.boolean :paid

      t.timestamps
    end
  end
end
