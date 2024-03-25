class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name,   null: false, default: ''
      t.decimal :price, null: false, default: 0
      t.string :status, null: false, default: 'approved'

      t.timestamps
    end
  end
end
