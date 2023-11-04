class AddFieldsToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :description, :text
    add_column :events, :starts_at, :datetime
  end
end
