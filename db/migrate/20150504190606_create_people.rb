class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :admin
      t.text :slug
      t.boolean :validated
      t.string :handle
      t.string :team

      t.timestamps
    end
  end
end
