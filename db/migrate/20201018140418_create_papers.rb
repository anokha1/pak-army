class CreatePapers < ActiveRecord::Migration[6.0]
  def change
    create_table :papers do |t|
      t.string :subject

      t.timestamps
    end
  end
end
