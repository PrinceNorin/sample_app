class AddPasswordResetToUser < ActiveRecord::Migration
  def change
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_expired, :datetime
  end
end
