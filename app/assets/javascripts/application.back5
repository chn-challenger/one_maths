// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require_tree .


function showSolutions() {
  $(document).ready(function() {
    $('.solution-link').show();
    $('.next-question').hide();
    $('.topic-solution-link').show();
    $('.topic-next-question').hide();

    $('.toggle-hide-video').hide();

    $('.toggle-video').on('click', function(event){
      event.preventDefault();
      var linkText = $(this).text();
      if (linkText == 'Show Video') {
        $(this).prev().css("display","");
        $(this).text('');
        $(this).append("<i class='fa fa-arrow-up' aria-hidden='true'></i> Hide Video");
        $(".toggle-hide-video").show();
      } else {
        $(this).prev().css("display","none");
        $(this).text('Show Video');
        $(".toggle-hide-video").hide();
      };
    });

    $('.toggle-hide-video').on('click', function(event){
      event.preventDefault();
      $(this).next().css("display","none");
      $(this).next().next().text('Show Video');
      $(".toggle-hide-video").hide();
    });

    $('.chapter-collapsable').next().hide();
    $('.lesson-div').hide();

    $(".topic-headings").css("margin","10px auto");
    $(".lesson-headings").css("margin","6px auto");
    $(".topic-questions-headings").css("margin","6px auto");

    $('.chapter-collapsable').on('click', function(event){
      event.preventDefault();
      if ($(this).next().is(':visible')){
        $(this).next().hide();
      } else {
        $(this).next().show();
      };
    });

    $('.lesson-collapsable').on('click', function(event){
      event.preventDefault();
      if ($(this).next().is(':visible')){
        $(this).next().hide();
      } else {
        $(this).next().show();
      };
    });


    var submitSolution = function(event){
      event.preventDefault();
      var identifier = event.target.id.split("-");
      var topicId = identifier[0];
      var lessonId = identifier[1];
      var lessonExp = $("#lesson-" +  lessonId  + "-exp");
      var topicExp = $("#topic-" +  topicId  + "-exp");
      var topicNextLevelExp = $("#topic-" +  topicId  + "-next-level-exp");
      var topicNextLevel = $("#topic-" +  topicId  + "-next-level");
      var endTopicExp = $("#end-topic-" +  topicId  + "-exp");
      var endTopicNextLevelExp = $("#end-topic-" +  topicId  + "-next-level-exp");
      var endTopicNextLevel = $("#end-topic-" +  topicId  + "-next-level");
      var submitSolutionForm = $(this).parent();
      var postAddress = submitSolutionForm.attr('action');

      var answersArray = [];
      var i = 1;

      while (i < 10) {
        var answerLabelClass = '.answer-label-' + i;
        var studentAnswerClass = '.student-answer-' + i;
        var answerLabel = $(this).siblings(".answer-answers").children(answerLabelClass).attr("for");
        if (!answerLabel) { break; }
        var exactLabel = answerLabel.replace("answers_", "");


        var studentAnswer = $(this).siblings(".answer-answers").children(studentAnswerClass).val();
        answersArray.push([exactLabel,studentAnswer]);
        i++;
      }

      var choice = submitSolutionForm.find('input:checked[name="choice"]').val();

      if (typeof choice == 'undefined' && answersArray.length == 0)
      {
        alert("You must first select an answer choice!");
        return;
      };

      var question_id = submitSolutionForm.find('input[name="question_id"]').val();
      var lesson_id = submitSolutionForm.find('input[name="lesson_id"]').val();
      var topic_id = submitSolutionForm.find('input[name="topic_id"]').val();
      var authenticity_token = submitSolutionForm.find('input[name="authenticity_token"]').val();
      var solutionTitle = $(this).siblings(".solution-title");
      var solutionText = $(this).siblings(".solution-text");
      var correctDiv = $(this).siblings("#correct");

      $(this).hide();
      $(this).siblings('.topic-next-question').show();
      $(this).siblings('.next-question').show();

      var params = {
        'choice':               choice,
        'js_answers':           answersArray,
        'question_id':          question_id,
        'lesson_id':            lesson_id,
        'topic_id':             topic_id,
        'authenticity_token':   authenticity_token }

      $.post(postAddress, params, function(response){
        solutionTitle.text("Solution");
        solutionText.text(response.question_solution);
        correctDiv.text(response.message);
        if (typeof lesson_id == 'undefined'){
          endTopicExp.text(response.topic_exp);
          endTopicNextLevelExp.text(response.topic_next_level_exp);
          endTopicNextLevel.text(response.topic_next_level);
        } else {
          lessonExp.text(response.lesson_exp);
        };
        topicExp.text(response.topic_exp);
        topicNextLevelExp.text(response.topic_next_level_exp);
        topicNextLevel.text(response.topic_next_level);

        if (response.choice) {
          correctDiv.css("color", "green");
        } else {
          correctDiv.css("color", "red");
        };
        MathJax.Hub.Typeset();
      });
    };


    var topicNextQuestion = function(event){
      event.preventDefault();
        var nextQuestionLink = $(this);
        var nextQuestionDiv = $(this).parent().parent();
        var nextQuestionForm = $(this).parent();
        var answerChoices = $(this).siblings('.answer-choices');
        var answerAnswers = $(this).siblings('.answer-answers');

      $.get(this.href, function(response){
        if (response.question == "") {
          nextQuestionDiv.empty();
          nextQuestionDiv.append("<div class='request-more-questions'>Well done! You have attempted all the questions available for this lesson, contact us to ask for more!</div>")
        } else {

          nextQuestionForm.siblings('.question-header').children('.question-exp').text(response.question.experience);

          if (typeof response.topic_bonus_exp == 'undefined'){
            nextQuestionForm.siblings('.question-header').children('.streak-mtp').text(response.lesson_bonus_exp);
          } else {
            nextQuestionForm.siblings('.question-header').children('.streak-mtp').text(response.topic_bonus_exp);
          };

          nextQuestionForm.siblings('.question-text').text(response.question.question_text);
          nextQuestionForm.children('.form-question-id').val(response.question.id);

          nextQuestionForm.children('.solution-title').text('');
          nextQuestionForm.children('.solution-text').text('');
          nextQuestionForm.children('.question-result').text('');

          answerChoices.empty();

          var choices = response.choices;
          for (var i = 0, len = choices.length; i < len; i++) {
            answerChoices.append("<input class='question-choice' type='radio' id='choice-"
              + choices[i].id +"' " + "name='choice' value=" + choices[i].id
              +  ">" + '<span style="padding-left:10px;">' + choices[i].content + '</span>' + "<br>");
          };

          answerAnswers.empty();

          var answers = response.answers;
          for (var i = 0, len = answers.length; i < len; i++) {
            answerAnswers.append(
                '<label class="answer-label-' + (i+1) + ' answer-label-style" for="answers_' + answers[i].label + '">' + answers[i].label + '</label>'
              + '<input class="student-answer-' + (i+1) + '" type="text" name="answers[' + answers[i].label + ']" id="answers_' + answers[i].label + '" />'
              + '<span class="answer-hint">' + answers[i].hint + '</span><br>'
            );
          };

          nextQuestionLink.hide();
          nextQuestionForm.children('.topic-solution-link').show();
          nextQuestionForm.children('.solution-link').show();
          MathJax.Hub.Typeset();
        };
      });
    };

    $('.solution-link').on('click',submitSolution);
    $('.next-question').on('click', topicNextQuestion);












  });
  MathJax.Hub.Typeset();
};
