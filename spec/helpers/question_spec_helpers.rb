def flag_question(user, question)
  if question.is_a?(Array)
    question.each { |q| user.flagged_questions.push(q) }
  else
    user.flagged_questions.push(question)
  end
end
