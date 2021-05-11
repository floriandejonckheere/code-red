# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :name, null: false
      t.string :description

      t.references :user, null: true, type: :uuid, foreign_key: { on_delete: :nullify }

      t.timestamps
    end
  end
end
