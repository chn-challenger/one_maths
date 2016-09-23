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
    start += '\changefontsizes[20pt]{14pt}'+ "\n"
    start += '\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}'+ "\n"
    start += '\pagenumbering{gobble}'+ "\n"
    start += '\usepackage{fancyhdr}'+ "\n"
    start += '\renewcommand{\headrulewidth}{0pt}'+ "\n"
    start += '\pagestyle{fancy}'+ "\n"
    start += '\lfoot{LEQ-FQ051323-Q\quad \textcopyright\, Joe Zhou, 2016}'+ "\n"
    start += '\rfoot{\textit{student:}\quad Any}'+ "\n"
    start += '\begin{document}'+ "\n"
    end_doc = '\end{document}'

    if can? :create, Question
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
        f.puts a
        f.puts end_doc
      end
    end
    redirect_to '/'
  end

end
