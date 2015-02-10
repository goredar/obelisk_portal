class AddDobToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :dob, :date
  end
end
