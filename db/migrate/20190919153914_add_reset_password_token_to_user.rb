class AddResetPasswordTokenToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :reset_password_token, :stringanonymous_user
    add_column :users, :reset_password_sent_at, :datetime
  end
end
