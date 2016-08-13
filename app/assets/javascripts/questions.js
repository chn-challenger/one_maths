$(document).ready(function() {
  $('.solution-link').on('click', function(event){
      event.preventDefault();
      var solutionDiv = $(this).siblings("#solution-latex");
      $.get(this.href, function(response){
        solutionDiv.text(response.question_solution);
        // solutionDiv.text(response.question.solution);
    })
  })
})
