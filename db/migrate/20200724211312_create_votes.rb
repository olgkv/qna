class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :value, null: false, default: 0
      t.references :votable, polymorphic: true
      t.references :user, null: false, foreign_key: true
      t.index([:votable_type, :votable_id, :user_id], unique: true)

      t.timestamps
    end
  end
end
