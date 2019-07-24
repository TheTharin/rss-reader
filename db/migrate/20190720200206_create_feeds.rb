# frozen_string_literal: true

class CreateFeeds < ActiveRecord::Migration[5.2]
  def change
    create_table :feeds do |t|
      t.string :title, null: false, index: true
      t.string :url, null: false

      t.timestamps
    end
  end
end
