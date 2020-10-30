class CreateMultipleChoices < ActiveRecord::Migration[6.0]
  def change
    create_table :multiple_choices do |t|
      t.string :option_a
      t.string :option_b
      t.string :option_c
      t.string :option_d
      t.string :option_e
      t.string :correct_option
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
