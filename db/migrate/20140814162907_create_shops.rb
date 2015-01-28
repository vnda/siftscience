class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :sift_api_key, null: false
      t.string :vnda_api_host, null: false
      t.string :vnda_api_user, null: false
      t.string :vnda_api_password, null: false
      t.string :token, limit: 32, null: false

      t.index :token, unique: true
      t.index :vnda_api_host, unique: true
    end
  end
end
