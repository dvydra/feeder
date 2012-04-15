class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :url
      t.string :title
      t.string :body
      t.string :published_at
      t.string :author

      t.timestamps
    end
  end
end
