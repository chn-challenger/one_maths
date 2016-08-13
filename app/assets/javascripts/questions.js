// $(document).ready(function() {
//
//   console.log("loaded")
//
//   $('.solution-link').on('click', function(event){
//       console.log("Am I ready");
//       event.preventDefault();
//       var solutionDiv = $(this).siblings("#solution-latex");
//       $.get(this.href, function(response){
//         solutionDiv.text(response.question_solution);
//         MathJax.Hub.Typeset();
//         // solutionDiv.text(response.question.solution);
//     })
//   })
// })
