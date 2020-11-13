class AddTimeToPapers < ActiveRecord::Migration[6.0]
  def change
    add_column :papers, :time, :string
  end
end
