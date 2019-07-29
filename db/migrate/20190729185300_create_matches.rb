class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.integer :follower_id
      t.integer :followee_id
    end
  end
end
