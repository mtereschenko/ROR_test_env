class CreateTodoLists < ActiveRecord::Migration[7.0]
  def change
    create_table :todo_lists do |table|
      table.string :title
      table.text :description

      table.timestamps
    end
  end
end
