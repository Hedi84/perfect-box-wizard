class SetDefaultRoleForUsers < ActiveRecord::Migration[8.1]
  def up
    execute("UPDATE users SET role = 0 WHERE role IS NULL")
    change_column_default :users, :role, from: nil, to: 0
    change_column_null :users, :role, false
  end

  def down
    change_column_null :users, :role, true
    change_column_default :users, :role, from: 0, to: nil
  end
end
