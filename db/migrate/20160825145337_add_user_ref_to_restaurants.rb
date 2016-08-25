class AddUserRefToRestaurants < ActiveRecord::Migration
  def change
    add_reference :restaurants, :user, index: true, foreign_key: true
  end

  # add_index :restaurants, :user_id
end
