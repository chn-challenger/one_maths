$(document).ready(function() {
  $('.solution-link').on('click', function(event){
      event.preventDefault();

      console.log("shit hshit");
      // var endorsementCount = $(this).siblings('.endorsements_count');

      $.get(this.href, function(response){
        console.log(response);
        // alert("Alert"+ response.new_endorsement_count);
        // endorsementCount.text(response.new_endorsement_count);
    })
  })
})




// $(document).ready(function() {
//     console.log("something happened");
//   $('.solution-link').on('click', function(event){
//       event.preventDefault();
//
//       // consoleee.log("something happened");
//       var solutionLatex = $("#solution-latex");
//
//       $.post(this.href, function(response){
//         solutionLatex.text(response.solution_latex);
//     });
//   });
// });
// $('.solution-link').on('click', function(event){
//     event.preventDefault();
//
//     console.log("something happenedddd");
//     var solutionLatex = $("#solution-latex");
//     solutionLatex.text("whatever");
//
//
//     $.get(this.href, function(response){
//       solutionLatex.text(response.solution_latex);
//   });
// });
// solutionLatex.text(response.solution_latex);

      //     $.get(url, function(response){
      //       var r = $.parseJSON(response);
      //      console.log(r.solution_latex);//This is where Your users are
      //     alert("Got stuff back" + r.solution_latex);
      //   });
      // });

    //      <a href="/questions/<%= question[:question_id]%>" class="solution-link">Show solution</a>

    // <% question_object = Question.find(question[:question_id])%>
    // <p>Question object name is <%= question_object.question_text %></p>
  //  <%= link_to "Show solution", question_path(question_object), class: 'solution-link' %>

      // $.ajax({
      // url: '/test',
      // type: 'POST',
      // contentType: "application/json",
      // data:JSON.stringify(params),
      // success: function(data){
      //   // console.log(data);
      //   // console.log("success");
      //   // window.location.replace("/test1");
      //   // window.location.replace("/game/new");
      //   // location.reload();
      // },
      // error: function(data) {
      //   // console.log(data)
      //   console.log("error happened");
      // }
      // });



      //
      // $(document).ready(function(){
      //
      //     $("#solution").toggle();
      //     $("#solution-button").click(function(){
      //         console.log('hi');
      //         $("#solution").toggle();
      //     });
      //
      //     $('.solution-link').on('click', function(event){
      //
      //         event.preventDefault();
      //
      //         console.log("something happenedddd");
      //         var solutionLatex = $("#solution-latex");
      //
      //         var thisurl = this.href;
      //         console.log(thisurl);
      //
      //         $.ajax({
      //            method: 'GET',
      //            url:  thisurl,
      //            dataType: "json",
      //            success: function(data) {
      //               var r = $.parseJSON(data);
      //               console.log(r.solution_latex);
      //               alert("Got stuff back" + r.solution_latex);
      //            }
      //        });
      //
      //
      // });
