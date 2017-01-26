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


$(document).on('turbolinks:load', function() {

  // $('#user-icon').mouseover( function(){
  //   $('#user-menu').slideDown("fast");
  // })
  //
  // $('.user-nav').mouseleave( function(){
  //   $('#user-menu').slideUp("fast");
  // })

  $('.chapter-collapsable').next().hide();
  $('.lesson-div').hide();

  $(".topic-headings").css("margin","10px auto");
  $(".lesson-headings").css("margin","6px auto");
  $(".topic-questions-headings").css("margin","6px auto");

  var collapsable = function(event){
    event.preventDefault();
    if ($(this).next().is(':visible')){
      $(this).next().hide(500);

      if ($(this).attr('class').match(/lesson/i)) {
        $(this).removeAttr('data-remote');
      }
    } else {
      $(this).next().show(500);
    }
  };

  $('.chapter-collapsable').on('click', collapsable);

  $('.lesson-collapsable').on('click', collapsable);
});

var changeMe;
$(document).on('turbolinks:load', function() {
  var inputObj, presenterObj;

  changeMe = function(inputId, presenterId) {
    inputObj = document.getElementById(inputId)
    presenterObj = document.getElementById(presenterId)

    var x = inputObj.value;
    presenterObj.innerHTML = x;
    showSolutions()
  }
});

// $(document).on('click',showSolutions())

$(document).on('turbolinks:load', function() {
  var acc, i, results;
  acc = document.getElementsByClassName('accordion');
  i = 0;
  results = [];
  while (i < acc.length) {
    acc[i].onclick = function() {
      this.classList.toggle('active');
      this.nextElementSibling.classList.toggle('show');
    };
    results.push(i++);
  }
  return results;
});

function checkAll() {
  $(":checkbox").prop("checked", true);
}

function uncheckAll() {
  $(":checkbox").prop("checked", false);
}
