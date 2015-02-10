class AddPhotoAndRoleToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :photo, :binary
    add_column :contacts, :role, :string
  end
end
