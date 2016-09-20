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


var fewsubmitSolution = function(event){
  event.preventDefault();
  var identifier = event.target.id.split("-");
  var topicId = identifier[0];
  var lessonId = identifier[1];
  var lessonExp = $("#lesson-" +  lessonId  + "-exp");
  var topicExp = $("#topic-" +  topicId  + "-exp");
  var topicNextLevelExp = $("#topic-" +  topicId  + "-next-level-exp");
  var topicNextLevel = $("#topic-" +  topicId  + "-next-level");
  var submitSolutionForm = $(this).parent();
  var postAddress = submitSolutionForm.attr('action');

  var answersArray = [];
  var i = 1;

  while (i < 10) {
    var answerLabelClass = '.answer-label-' + i;
    var studentAnswerClass = '.student-answer-' + i;
    var answerLabel = $(this).siblings(".answer-answers").children(answerLabelClass).text();
    if (answerLabel == '') { break; }
    var studentAnswer = $(this).siblings(".answer-answers").children(studentAnswerClass).val();
    answersArray.push([answerLabel,studentAnswer]);
    i++;
  }

  var choice = submitSolutionForm.find('input:checked[name="choice"]').val();

  var question_id = submitSolutionForm.find('input[name="question_id"]').val();
  var lesson_id = submitSolutionForm.find('input[name="lesson_id"]').val();
  var authenticity_token = submitSolutionForm.find('input[name="authenticity_token"]').val();
  var solutionTitle = $(this).siblings(".solution-title");
  var solutionText = $(this).siblings(".solution-text");
  var correctDiv = $(this).siblings("#correct");

  $(this).hide();
  $(this).siblings('.next-question').show();

  var params = {
    'choice':               choice,
    'js_answers':           answersArray,
    'question_id':          question_id,
    'lesson_id':            lesson_id,
    'authenticity_token':   authenticity_token }

  $.post(postAddress, params, function(response){
    solutionTitle.text("Solution");
    solutionText.text(response.question_solution);
    correctDiv.text(response.message);
    lessonExp.text(response.lesson_exp);
    topicExp.text(response.topic_exp);
    topicNextLevelExp.text(response.topic_next_level_exp);
    topicNextLevel.text(response.topic_next_level);
    //
    if (response.choice) {
      correctDiv.css("color", "green");
    } else {
      correctDiv.css("color", "red");
    };
    MathJax.Hub.Typeset();
  });
};
