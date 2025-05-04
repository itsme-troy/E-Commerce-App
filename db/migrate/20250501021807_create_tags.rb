class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :tag_type
      t.integer :created_by

      t.timestamps
    end
  end
end
