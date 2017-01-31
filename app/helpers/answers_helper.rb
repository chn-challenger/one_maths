module AnswersHelper
  ANSWER_HINTS = YAML.load_file("#{Rails.root}/config/one_maths_config.yml")['hints']

  def fetch_hints
    YAML.load_file(Settings::SettingsController::ONE_MATH_CONFIG_PATH)['hints']
  end

  def print_hint(hint)
    if hint_index?(hint)
      ANSWER_HINTS[hint.to_i]
    else
      hint
    end
  end

  protected

  def hint_index?(hint)
    /^\d+$/ === hint
  end
end
