class RenameAdminToCreatedByInProducts < ActiveRecord::Migration[8.0]
  def change
    rename_column :products, :admin_id, :created_by_id
  end
end
