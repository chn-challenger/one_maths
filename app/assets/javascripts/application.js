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

  if (window.location.pathname.match(/^\/teachers$/)) {
    var target = document.getElementById('content')

    var observer = new MutationObserver(function() {
      collapsableElements(false);
    })

    config = { childList: true, characterData: true };

    observer.observe(target, config);
  }

  collapsableElements(true);
});

$(document).on('turbolinks:load', function() {
  $('body').on('click', '.toggle-video', videoToggle)
  $('body').on('click', '.toggle-hide-video', videoToggle)
})

function videoToggle(event) {
  var element = event.target;
  console.log(element.className);
  if(element.className === 'toggle-video') {
    event.preventDefault();
    var linkText = $(this).text();
    var hideVideo = $(this).siblings(".toggle-hide-video");
    if (linkText === 'Show Video') {
      $(this).prev().css("display","");
      $(this).text('');
      $(this).append("<i class='fa fa-arrow-up' aria-hidden='true'></i> Hide Video");
      hideVideo.show();
    } else {
      $(this).prev().css("display","none");
      $(this).text('Show Video');
      hideVideo.hide();
    }
  }
  if (element.className === 'toggle-hide-video') {
    event.preventDefault();
    $(this).next().css("display","none");
    $(this).next().next().text('Show Video');
    $(this).hide();
  }
}

function collapsableElements(boolean) {
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

  if (boolean) {
    $('.lesson-collapsable').on('click', collapsable);
  }
}

var changeMe;
$(document).on('turbolinks:load', function() {
  var inputObj, presenterObj;
  var notSet = true;

  insertTextArea = function(inputObj) {
      id = $(inputObj).attr('id')
      onchange = $(inputObj).attr('onchange')
      identifier = id[id.length-1]

      if (window.location.pathname.match(/new/)) {
        $(inputObj).after('<textarea onchange="changeMe(\''+ id  + '\',\'answer-hint-'+ identifier +'\')" oninput="this.onchange()" name="answers[][hint]" id=' + id + '></textarea>')
      } else {
        current_hint = document.getElementById('answer-hint-presenter').innerHTML

        $(inputObj).after('<textarea onchange="changeMe(\'answer_hint\',\'answer-hint-presenter\')" oninput="this.onchange()" name="answer[hint]" id=' + id + '>' + current_hint + '</textarea>')
      }

      $(inputObj).attr('id', '')
      $(inputObj).attr('name', '')
      notSet = false
  }

  changeMe = function(inputId, presenterId) {

    inputObj = document.getElementById(inputId)
    presenterObj = document.getElementById(presenterId)

    if (inputObj.nodeName === 'SELECT') {
      if ($(inputObj).find(':selected').text() === 'Other') {
        insertTextArea(inputObj)
      }
    }

    var x = inputObj.value;
    presenterObj.innerHTML = x;
    MathJax.Hub.Typeset();
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
