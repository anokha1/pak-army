class CreateUserAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :user_answers do |t|
      t.boolean :is_correct, default: false
      t.string :selected_option
      t.references :question, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :paper, null: false, foreign_key: true

      t.timestamps
    end
  end
end
user