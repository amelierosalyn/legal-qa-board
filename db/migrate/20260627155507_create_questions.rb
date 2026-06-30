class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :body
      t.string :category
      t.integer :status

      t.timestamps
    end
  end
end
