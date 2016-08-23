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



// function showSolutions() {
//   $(document).ready(function() {
//
//     $('.solution-link').on('click', function(event){
//       var postAddress = $(this).parent('form')[0].action;
//       var choice = $(this).parent('form').find('input:checked[name="choice"]').val();
//       event.preventDefault();
//       var solutionDiv = $(this).siblings("#solution-latex");
//       var correctDiv = $(this).siblings("#correct");
//       $.get(postAddress, { 'choice': choice }, function(response){
//         solutionDiv.text(response.question_solution);
//         correctDiv.text(response.message);
//         MathJax.Hub.Typeset();
//       })
//     })
//   })
//   MathJax.Hub.Typeset();
// };
















// function showSolutions() {
//   $(document).ready(function() {
//
//     $('.solution-link').on('click', function(event){
//       event.preventDefault();
//       var solutionDiv = $(this).siblings("#solution-latex");
//       $.get(this.href, function(response){
//         solutionDiv.text(response.question_solution);
//         MathJax.Hub.Typeset();
//       })
//     })
//   })
//   MathJax.Hub.Typeset();
// };
