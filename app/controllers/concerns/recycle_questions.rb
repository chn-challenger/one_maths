module RecycleQuestions
  extend ActiveSupport::Concern

  def reset_questions(lesson, user)
    ans_qs = user.answered_questions.where(lesson_id: lesson.id, correct: false, correctness: 0.0)
    question_ids = ans_qs.pluck(:question_id)

    question_ids.each do |id|
      qr = user.question_resets.where(lesson_id: lesson.id, question_id: id).first_or_initialize(lesson_id: lesson.id, question_id: id, count: 1)

      if qr.new_record?
        qr.save!
      else
        qr.update(count: qr.count + 1)
      end
    end

    user.answered_questions.delete(ans_qs)
  end

end
