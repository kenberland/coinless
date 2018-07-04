class AddRsvpTable < ActiveRecord::Migration[5.2]
  def change
    create_table :rsvps do |t|
      t.string :email
      t.string :event
      t.integer :heads
      t.index [:email, :event], unique: true
      t.datetime :updated_at
    end
  end
end
