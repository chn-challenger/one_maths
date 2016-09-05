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

    $('.solution-link').on('click', function(event){
      $(this).parent('form').siblings('.next-question').show();

      var postAddress = $(this).parent('form')[0].action;
      var choice = $(this).parent('form').find('input:checked[name="choice"]').val();
      var question_id = $(this).parent('form').find('input[name="question_id"]').val();
      var authenticity_token = $(this).parent('form').find('input[name="authenticity_token"]').val();
      event.preventDefault();
      var solutionDiv = $(this).siblings("#solution-latex");
      var correctDiv = $(this).siblings("#correct");
      $.post(postAddress, { 'choice': choice, 'question_id': question_id, 'authenticity_token': authenticity_token }, function(response){
        solutionDiv.text(response.question_solution);
        correctDiv.text(response.message);

        if (response.choice == "true") {
          correctDiv.css("color", "green");
        } else {
          correctDiv.css("color", "red");
        };

        MathJax.Hub.Typeset();
      });
    });

    $('.next-question').on('click', function(event){
      event.preventDefault();
        var nextQuestionLink = $(this);
        var nextQuestionDiv = $(this).parent('div');
        var nextQuestionForm = $(this).siblings('form');

      $.get(this.href, function(response){

        nextQuestionDiv.children().eq(1).text(response.question.question_text);
        nextQuestionForm.children().eq(2).val(response.question.id);
        var utfInput = nextQuestionForm.children().eq(0);
        var tokenInput = nextQuestionForm.children().eq(1);
        var questionIdInput = nextQuestionForm.children().eq(2);
        var solutionLatexDiv = nextQuestionForm.children().last();
        solutionLatexDiv.text('');
        nextQuestionForm.children().last().remove();
        var correctDiv = nextQuestionForm.children().last();
        correctDiv.text('');
        nextQuestionForm.children().last().remove();
        var submitInput = nextQuestionForm.children().last();
        nextQuestionForm.children().last().remove();

        nextQuestionForm.empty();

        nextQuestionForm.append(utfInput);
        nextQuestionForm.append(tokenInput);
        nextQuestionForm.append(questionIdInput);
        var choices = response.choices;
        for (var i = 0, len = choices.length; i < len; i++) {
          nextQuestionForm.append("<input class='question-choice' type='radio' id='choice-"
            + choices[i].id +"' " + "name='choice' value=" + choices[i].correct
            +  ">" + '<span style="padding-left:10px;">' + choices[i].content + '</span>' + "<br>");
        };
        nextQuestionForm.append(submitInput);
        nextQuestionForm.append(correctDiv);
        nextQuestionForm.append(solutionLatexDiv);

        nextQuestionLink.hide();
        nextQuestionForm.children('.solution-link').show();
        MathJax.Hub.Typeset();

        $('.solution-link').on('click', function(event){
          $('.solution-link').hide();
          $('.next-question').show();
          var postAddress = $(this).parent('form')[0].action;
          var choice = $(this).parent('form').find('input:checked[name="choice"]').val();
          var question_id = $(this).parent('form').find('input[name="question_id"]').val();
          var authenticity_token = $(this).parent('form').find('input[name="authenticity_token"]').val();
          event.preventDefault();
          var solutionDiv = $(this).siblings("#solution-latex");
          var correctDiv = $(this).siblings("#correct");
          $.post(postAddress, { 'choice': choice, 'question_id': question_id, 'authenticity_token': authenticity_token }, function(response){
            solutionDiv.text(response.question_solution);
            correctDiv.text(response.message);

            if (response.choice == "true") {
              correctDiv.css("color", "green");
            } else {
              correctDiv.css("color", "red");
            };

            MathJax.Hub.Typeset();
          });
        });


      });
    });


  });
  MathJax.Hub.Typeset();
};






























// function showSolutions() {
//   $(document).ready(function() {
//
//     $('.next-question').hide();
//
//     $('.solution-link').on('click', function(event){
//       $('.solution-link').hide();
//       $('.next-question').show();
//       var postAddress = $(this).parent('form')[0].action;
//       var choice = $(this).parent('form').find('input:checked[name="choice"]').val();
//       var question_id = $(this).parent('form').find('input[name="question_id"]').val();
//       var authenticity_token = $(this).parent('form').find('input[name="authenticity_token"]').val();
//       event.preventDefault();
//       var solutionDiv = $(this).siblings("#solution-latex");
//       var correctDiv = $(this).siblings("#correct");
//       $.post(postAddress, { 'choice': choice, 'question_id': question_id, 'authenticity_token': authenticity_token }, function(response){
//         solutionDiv.text(response.question_solution);
//         correctDiv.text(response.message);
//         MathJax.Hub.Typeset();
//       });
//     });
//
//     $('.next-question').on('click', function(event){
//       event.preventDefault();
//
//       $.get(this.href, function(response){
//
//         $('.question-div').children().eq(2).text(response.question.question_text);
//         $('.question-div .edit_question').children().eq(2).val(response.question.id);
//         var utfInput = $('.question-div .edit_question').children().eq(0);
//         var tokenInput = $('.question-div .edit_question').children().eq(1);
//         var questionIdInput = $('.question-div .edit_question').children().eq(2);
//         var solutionLatexDiv = $('.question-div .edit_question').children().last();
//         solutionLatexDiv.text('');
//         $('.question-div .edit_question').children().last().remove();
//         var correctDiv = $('.question-div .edit_question').children().last();
//         correctDiv.text('');
//         $('.question-div .edit_question').children().last().remove();
//         var submitInput = $('.question-div .edit_question').children().last();
//         $('.question-div .edit_question').children().last().remove();
//
//         $('.question-div .edit_question').empty();
//
//         $('.question-div .edit_question').append(utfInput);
//         $('.question-div .edit_question').append(tokenInput);
//         $('.question-div .edit_question').append(questionIdInput);
//         var choices = response.choices;
//         for (var i = 0, len = choices.length; i < len; i++) {
//           $('.question-div .edit_question').append("<input type='radio' id='choice-"
//             + choices[i].id +"' " + "name='choice' value=" + choices[i].correct
//             +  ">" + "<span>" + choices[i].content + "</span>" + "<br>");
//         };
//         $('.question-div .edit_question').append(submitInput);
//         $('.question-div .edit_question').append(correctDiv);
//         $('.question-div .edit_question').append(solutionLatexDiv);
//
//         $('.next-question').hide();
//         $('.solution-link').show();
//
//         $('.solution-link').on('click', function(event){
//           $('.solution-link').hide();
//           $('.next-question').show();
//           var postAddress = $(this).parent('form')[0].action;
//           var choice = $(this).parent('form').find('input:checked[name="choice"]').val();
//           var question_id = $(this).parent('form').find('input[name="question_id"]').val();
//           var authenticity_token = $(this).parent('form').find('input[name="authenticity_token"]').val();
//           event.preventDefault();
//           var solutionDiv = $(this).siblings("#solution-latex");
//           var correctDiv = $(this).siblings("#correct");
//           $.post(postAddress, { 'choice': choice, 'question_id': question_id, 'authenticity_token': authenticity_token }, function(response){
//             solutionDiv.text(response.question_solution);
//             correctDiv.text(response.message);
//             MathJax.Hub.Typeset();
//           });
//         });
//
//       });
//     });
//
//
//
//
//
//
//
//
//
//   });
//   MathJax.Hub.Typeset();
// };
