class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|

      t.string :login, null: false, index: true
      t.string :name
      t.string :extension
      t.string :mobile
      t.string :home
      t.string :company
      t.string :department
      t.string :title
      t.string :address

      t.timestamps null: false
    end
  end
end
