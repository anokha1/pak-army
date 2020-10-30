class CreatePaperTests < ActiveRecord::Migration[6.0]
  def change
    create_table :paper_tests do |t|
      t.references :paper, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
