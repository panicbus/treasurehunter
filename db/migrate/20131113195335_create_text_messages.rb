class CreateTextMessages < ActiveRecord::Migration
  def change
    create_table :text_messages do |t|
      t.string :user_phone_number

      t.timestamps
    end
  end
end
