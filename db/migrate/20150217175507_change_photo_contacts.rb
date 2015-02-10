class ChangePhotoContacts < ActiveRecord::Migration
  def change
    change_column :contacts, :photo, :string
  end
end
