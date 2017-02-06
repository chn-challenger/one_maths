module AnswersHelper
  ANSWER_HINTS = YAML.load_file("#{Rails.root}/config/one_maths_hints.yml")['hints']

  def print_hint(hint)
    if hint_index?(hint)
      ANSWER_HINTS[hint.to_i]
    else
      hint
    end
  end

  protected

  def load_hints
    YAML.load_file("#{Rails.root}/config/one_maths_hints.yml")['hints']
  end

  def hint_index?(hint)
    /^\d+$/ === hint
  end
end
