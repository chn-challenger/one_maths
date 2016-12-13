class CreateQuestionsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :questions_users, id: false do |t|
      t.belongs_to :question, index: true
      t.belongs_to :user, index: true
    end
  end
end
