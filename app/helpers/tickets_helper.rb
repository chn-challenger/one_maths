module TicketsHelper

  def closed?(ticket)
    ticket.status == 'Closed'
  end

  def description(ticket)
    comments = ticket.comments
    if comments.empty?
      'No comments'
    else
      ticket.comments.first.text[0..70] << '...'
    end
  end

  def display_tags(ticket)
    tags = ticket.tags
    if tags.empty?
      "No Category"
    else
      tags.first.name
    end
  end

  def fetch_tags(ticket)
    tags = ticket.tags
    return [] if tags.empty?
    tags.map { |tag| tag.name }.join(" ")
  end

  def fetch_student_answer(question, student)
    answer = AnsweredQuestion.find_by(question_id: question.id, user_id: student.id)
    return '<b>No answer has been recorded</b>'.html_safe if answer.blank?
    "<b>Correct: #{answer.correct}</b></br>".html_safe +
    answer.answer.map {|k, v| k.to_s + v.to_s }.join('</br>').html_safe
  end

end
