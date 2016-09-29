class AddAttachmentSolutionImageToQuestions < ActiveRecord::Migration
  def self.up
    change_table :questions do |t|
      t.attachment :solution_image
    end
  end

  def self.down
    remove_attachment :questions, :solution_image
  end
end
