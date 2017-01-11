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
  $('.chapter-collapsable').next().hide();
  $('.lesson-div').hide();

  $(".topic-headings").css("margin","10px auto");
  $(".lesson-headings").css("margin","6px auto");
  $(".topic-questions-headings").css("margin","6px auto");

  var collapsable = function(event){
    event.preventDefault();
    if ($(this).next().is(':visible')){
      $(this).next().hide();

      if ($(this).attr('class').match(/lesson/i)) {
        $(this).removeAttr('data-remote');
      }
    } else {
      $(this).next().show();
    }
  };

  $('.chapter-collapsable').on('click', collapsable);

  $('.lesson-collapsable').on('click', collapsable);
});

$(document).on('turbolinks:load', function() {
  document.querySelector('body').addEventListener('click', function(event) {
    var target = $( event.target )
    if (event.target.className === 'toggle-video') {
      event.preventDefault();
      var linkText = target.text();
      var hideVideo = target.siblings(".toggle-hide-video");
      if (linkText === 'Show Video') {
        target.prev().css("display","");
        target.text('');
        target.append("<i class='fa fa-arrow-up' aria-hidden='true'></i> Hide Video");
        hideVideo.show();
      } else {
        target.prev().css("display","none");
        target.text('Show Video');
        hideVideo.hide();
      }
    }

    if (event.target.className === 'toggle-hide-video') {
      event.preventDefault();
      target.next().css("display","none");
      target.next().next().text('Show Video');
      target.hide();
    }
  });
});

var changeMe;
$(document).ready( function() {
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

$(document).ready(function() {
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
