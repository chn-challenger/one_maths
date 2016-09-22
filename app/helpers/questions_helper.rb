module QuestionsHelper
  def standardise_answer(answer)
    answer.gsub(/[A-Za-z]|[ \t\r\n\v\f]/,"").split(',').map! do |num|
      '%.2f' % ((num.to_f * 100).round / 100.0)
    end.sort
  end
end

# standard_answer = answer.gsub(/[A-Za-z]|[ \t\r\n\v\f]/,"").split(',')
# standard_answer.map! do |num|
#   n = (num.to_f * 100).round / 100.0
#   '%.2f' % n
# end
# standard_answer.sort!
# standard_answer
