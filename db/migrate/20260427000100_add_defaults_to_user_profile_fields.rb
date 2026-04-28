class AddDefaultsToUserProfileFields < ActiveRecord::Migration[6.1]
  def up
    change_column_default :users, :role, from: nil, to: 'user'
    change_column_default :users, :status, from: nil, to: 'active'

    User.reset_column_information
    User.where(role: nil).update_all(role: 'user')
    User.where(status: nil).update_all(status: 'active')
    User.where(status: 'disable').update_all(status: 'disabled')

    change_column_null :users, :role, false
    change_column_null :users, :status, false
  end

  def down
    change_column_null :users, :status, true
    change_column_null :users, :role, true
    change_column_default :users, :status, from: 'active', to: nil
    change_column_default :users, :role, from: 'user', to: nil
  end
end
