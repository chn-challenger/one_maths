class CurrentQuestionLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    "#{timestamp.to_formatted_s(:db)} #{severity} #{msg}\n"
  end
end

logfile = File.open("#{Rails.root}/log/current_questions.log", 'a') # creates log file
logfile.sync = true # auto flush data to file
CURRENT_QUESTION_LOGGER = CurrentQuestionLogger.new(logfile)
