class Addisblocktousers < ActiveRecord::Migration[6.0]
  def change
    add_column :users,:is_block,:boolean, default: false
  end
end
