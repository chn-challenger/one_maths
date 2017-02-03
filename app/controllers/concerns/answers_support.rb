module AnswersSupport
  extend ActiveSupport::Concern

  def set_hint(answers)
    return if answers.blank?
    new_answers = answers.each do |answer|
      answer.hint = fetch_hint(answer.hint)
    end
    new_answers
  end

  private

  def fetch_hint(hint)
    if hint_index?(hint)
      AnswersHelper::ANSWER_HINTS[hint.to_i]
    else
      hint
    end
  end

  def hint_index?(hint)
    /^\d+$/ === hint
  end

end
