class AddLatLngToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :lat, :decimal
    add_column :properties, :lng, :decimal
  end
end
