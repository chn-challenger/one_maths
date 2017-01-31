require 'rake'

namespace :answers do
  desc 'Sets the order of all answers in the database'
  task :set_order => :environment do
    puts 'Starting Process of fetching questions with answers and updating order.'
    Question.joins(:answers).uniq.each do |question|
      question.answers.order(:created_at).each_with_index do |answer, index|
        answer.update(order: index)
      end
    end
    puts 'Printing finished all answers updated.'
    p Question.joins(:answers).uniq.first.answers
  end
end
