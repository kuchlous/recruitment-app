class CreateFormConfigs < ActiveRecord::Migration[8.0]
  def change
    create_table :form_configs do |t|
      t.string :title
      t.json :config

      t.timestamps
    end
  end
end
