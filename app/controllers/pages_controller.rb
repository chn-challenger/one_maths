class PagesController < ApplicationController

  def home
    redirect_to '/'
  end

  def about
  end

  def faq
  end

  def blog
  end

  def contact
  end

  def test_file
    start = '\documentclass{article}' + "\n"
    start += '\usepackage[math]{iwona}'+ "\n"
    start += '\usepackage[fleqn]{amsmath}'+ "\n"
    start += '\usepackage{scrextend}'+ "\n"
    start += '\usepackage{amsmath,amssymb}'+ "\n"
    start += '\changefontsizes[12pt]{8pt}'+ "\n"
    start += '\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}'+ "\n"
    start += '\pagenumbering{gobble}'+ "\n"
    start += '\usepackage{fancyhdr}'+ "\n"
    start += '\renewcommand{\headrulewidth}{0pt}'+ "\n"
    start += '\pagestyle{fancy}'+ "\n"
    start += '\lfoot{\textcopyright\, One Maths Limited}'+ "\n"
    start += '\rfoot{}'+ "\n"
    start += '\begin{document}'+ "\n"
    end_doc = '\end{document}'

    if can? :create, Question
      text_content = ""
      Course.all.each do |course|
        text_content += '\noindent\Huge{\textbf{' + course.name + '}}\\\\[5pt]' + "\n"
        text_content += '\noindent\large{' + course.description + '}\\\\[20pt]' + "\n"
        course.units.each_with_index do |unit,unit_i|
          text_content += '\noindent\huge{\textbf{' + "Unit #{unit_i + 1} " + unit.name + '}}\\\\[18pt]' + "\n"
          unit.topics.each_with_index do |topic,topic_i|
            text_content += '\noindent\huge{\textbf{' + "Chapter #{topic_i + 1} " + topic.name + '}}\\\\[15pt]' + "\n"
            topic.lessons.each_with_index do |lesson,lesson_i|
              text_content += '\noindent\large{\textbf{' + "Lesson #{lesson_i + 1} " + lesson.name + '}}\\\\[12pt]' + "\n"
              lesson.questions.each_with_index do |question,question_i|
                text_content += "\\noindent\\textbf{Question #{question_i+1}}\\\\[2pt]\n"
                text_content += question.question_text

                tail = ""
                (1..6).each do |n|
                  tail += text_content[n*-1]
                end

                if tail == "}*ngil"
                  # text_content += '\\\\[4pt]'
                else
                  text_content += '\\\\[4pt]'
                end

                # \vspace*{-\baselineskip}

                # text_content += '\\\\[4pt]'
                text_content += "\n"
                text_content += "\\noindent\\textbf{Solution #{question_i+1}}\\\\[2pt]\n"

                head = question.solution.slice(0,14)
                if head = '\begin{align*}'
                  text_content += '\\\\[-10pt]'
                end


                text_content += question.solution

                tail = ""
                (1..6).each do |n|
                  tail += text_content[n*-1]
                end

                if tail == "}*ngil"
                  # text_content += '\\\\[4pt]'
                else
                  text_content += '\\\\[4pt]'
                end


                # text_content += '\\\\[4pt]'
                text_content += "\n"



                question.choices.each do |choice|

                end

                question.answers.each do |choice|

                end

              end
            end
            text_content += '\\\\[2pt]' + "\n"
          end
        end
      end

      a = ""
      Question.all.each_with_index do |q,i|
        a += "\\noindent\\textbf{Question #{i+1}}\\\\[5pt]\n"
        a += q.question_text
        a += '\\\\[5pt]'
        a += "\n"
        a += "\\noindent\\textbf{Solution #{i+1}}\\\\[5pt]\n"
        a += q.solution
        a += '\\\\[10pt]'
        a += "\n\n"
      end
      a.gsub!("£","$\\pounds$")

      File.open('test.tex', 'w') do |f|
        f.puts start
        f.puts text_content
        f.puts end_doc
      end
    end
    redirect_to '/'
  end

end
