class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :customer
      t.string :product
      t.string :platform
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
