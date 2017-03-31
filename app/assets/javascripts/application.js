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
      updateExpBar();
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

/* ========================================================================
 * Bootstrap: modal.js v3.3.7
 * http://getbootstrap.com/javascript/#modals
 * ========================================================================
 * Copyright 2011-2016 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // MODAL CLASS DEFINITION
  // ======================

  var Modal = function (element, options) {
    this.options             = options
    this.$body               = $(document.body)
    this.$element            = $(element)
    this.$dialog             = this.$element.find('.modal-dialog')
    this.$backdrop           = null
    this.isShown             = null
    this.originalBodyPad     = null
    this.scrollbarWidth      = 0
    this.ignoreBackdropClick = false

    if (this.options.remote) {
      this.$element
        .find('.modal-content')
        .load(this.options.remote, $.proxy(function () {
          this.$element.trigger('loaded.bs.modal')
        }, this))
    }
  }

  Modal.VERSION  = '3.3.7'

  Modal.TRANSITION_DURATION = 300
  Modal.BACKDROP_TRANSITION_DURATION = 150

  Modal.DEFAULTS = {
    backdrop: true,
    keyboard: true,
    show: true
  }

  Modal.prototype.toggle = function (_relatedTarget) {
    return this.isShown ? this.hide() : this.show(_relatedTarget)
  }

  Modal.prototype.show = function (_relatedTarget) {
    var that = this
    var e    = $.Event('show.bs.modal', { relatedTarget: _relatedTarget })

    this.$element.trigger(e)

    if (this.isShown || e.isDefaultPrevented()) return

    this.isShown = true

    this.checkScrollbar()
    this.setScrollbar()
    this.$body.addClass('modal-open')

    this.escape()
    this.resize()

    this.$element.on('click.dismiss.bs.modal', '[data-dismiss="modal"]', $.proxy(this.hide, this))

    this.$dialog.on('mousedown.dismiss.bs.modal', function () {
      that.$element.one('mouseup.dismiss.bs.modal', function (e) {
        if ($(e.target).is(that.$element)) that.ignoreBackdropClick = true
      })
    })

    this.backdrop(function () {
      var transition = $.support.transition && that.$element.hasClass('fade')

      if (!that.$element.parent().length) {
        that.$element.appendTo(that.$body) // don't move modals dom position
      }

      that.$element
        .show()
        .scrollTop(0)

      that.adjustDialog()

      if (transition) {
        that.$element[0].offsetWidth // force reflow
      }

      that.$element.addClass('in')

      that.enforceFocus()

      var e = $.Event('shown.bs.modal', { relatedTarget: _relatedTarget })

      transition ?
        that.$dialog // wait for modal to slide in
          .one('bsTransitionEnd', function () {
            that.$element.trigger('focus').trigger(e)
          })
          .emulateTransitionEnd(Modal.TRANSITION_DURATION) :
        that.$element.trigger('focus').trigger(e)
    })
  }

  Modal.prototype.hide = function (e) {
    if (e) e.preventDefault()

    e = $.Event('hide.bs.modal')

    this.$element.trigger(e)

    if (!this.isShown || e.isDefaultPrevented()) return

    this.isShown = false

    this.escape()
    this.resize()

    $(document).off('focusin.bs.modal')

    this.$element
      .removeClass('in')
      .off('click.dismiss.bs.modal')
      .off('mouseup.dismiss.bs.modal')

    this.$dialog.off('mousedown.dismiss.bs.modal')

    $.support.transition && this.$element.hasClass('fade') ?
      this.$element
        .one('bsTransitionEnd', $.proxy(this.hideModal, this))
        .emulateTransitionEnd(Modal.TRANSITION_DURATION) :
      this.hideModal()
  }

  Modal.prototype.enforceFocus = function () {
    $(document)
      .off('focusin.bs.modal') // guard against infinite focus loop
      .on('focusin.bs.modal', $.proxy(function (e) {
        if (document !== e.target &&
            this.$element[0] !== e.target &&
            !this.$element.has(e.target).length) {
          this.$element.trigger('focus')
        }
      }, this))
  }

  Modal.prototype.escape = function () {
    if (this.isShown && this.options.keyboard) {
      this.$element.on('keydown.dismiss.bs.modal', $.proxy(function (e) {
        e.which == 27 && this.hide()
      }, this))
    } else if (!this.isShown) {
      this.$element.off('keydown.dismiss.bs.modal')
    }
  }

  Modal.prototype.resize = function () {
    if (this.isShown) {
      $(window).on('resize.bs.modal', $.proxy(this.handleUpdate, this))
    } else {
      $(window).off('resize.bs.modal')
    }
  }

  Modal.prototype.hideModal = function () {
    var that = this
    this.$element.hide()
    this.backdrop(function () {
      that.$body.removeClass('modal-open')
      that.resetAdjustments()
      that.resetScrollbar()
      that.$element.trigger('hidden.bs.modal')
    })
  }

  Modal.prototype.removeBackdrop = function () {
    this.$backdrop && this.$backdrop.remove()
    this.$backdrop = null
  }

  Modal.prototype.backdrop = function (callback) {
    var that = this
    var animate = this.$element.hasClass('fade') ? 'fade' : ''

    if (this.isShown && this.options.backdrop) {
      var doAnimate = $.support.transition && animate

      this.$backdrop = $(document.createElement('div'))
        .addClass('modal-backdrop ' + animate)
        .appendTo(this.$body)

      this.$element.on('click.dismiss.bs.modal', $.proxy(function (e) {
        if (this.ignoreBackdropClick) {
          this.ignoreBackdropClick = false
          return
        }
        if (e.target !== e.currentTarget) return
        this.options.backdrop == 'static'
          ? this.$element[0].focus()
          : this.hide()
      }, this))

      if (doAnimate) this.$backdrop[0].offsetWidth // force reflow

      this.$backdrop.addClass('in')

      if (!callback) return

      doAnimate ?
        this.$backdrop
          .one('bsTransitionEnd', callback)
          .emulateTransitionEnd(Modal.BACKDROP_TRANSITION_DURATION) :
        callback()

    } else if (!this.isShown && this.$backdrop) {
      this.$backdrop.removeClass('in')

      var callbackRemove = function () {
        that.removeBackdrop()
        callback && callback()
      }
      $.support.transition && this.$element.hasClass('fade') ?
        this.$backdrop
          .one('bsTransitionEnd', callbackRemove)
          .emulateTransitionEnd(Modal.BACKDROP_TRANSITION_DURATION) :
        callbackRemove()

    } else if (callback) {
      callback()
    }
  }

  // these following methods are used to handle overflowing modals

  Modal.prototype.handleUpdate = function () {
    this.adjustDialog()
  }

  Modal.prototype.adjustDialog = function () {
    var modalIsOverflowing = this.$element[0].scrollHeight > document.documentElement.clientHeight

    this.$element.css({
      paddingLeft:  !this.bodyIsOverflowing && modalIsOverflowing ? this.scrollbarWidth : '',
      paddingRight: this.bodyIsOverflowing && !modalIsOverflowing ? this.scrollbarWidth : ''
    })
  }

  Modal.prototype.resetAdjustments = function () {
    this.$element.css({
      paddingLeft: '',
      paddingRight: ''
    })
  }

  Modal.prototype.checkScrollbar = function () {
    var fullWindowWidth = window.innerWidth
    if (!fullWindowWidth) { // workaround for missing window.innerWidth in IE8
      var documentElementRect = document.documentElement.getBoundingClientRect()
      fullWindowWidth = documentElementRect.right - Math.abs(documentElementRect.left)
    }
    this.bodyIsOverflowing = document.body.clientWidth < fullWindowWidth
    this.scrollbarWidth = this.measureScrollbar()
  }

  Modal.prototype.setScrollbar = function () {
    var bodyPad = parseInt((this.$body.css('padding-right') || 0), 10)
    this.originalBodyPad = document.body.style.paddingRight || ''
    if (this.bodyIsOverflowing) this.$body.css('padding-right', bodyPad + this.scrollbarWidth)
  }

  Modal.prototype.resetScrollbar = function () {
    this.$body.css('padding-right', this.originalBodyPad)
  }

  Modal.prototype.measureScrollbar = function () { // thx walsh
    var scrollDiv = document.createElement('div')
    scrollDiv.className = 'modal-scrollbar-measure'
    this.$body.append(scrollDiv)
    var scrollbarWidth = scrollDiv.offsetWidth - scrollDiv.clientWidth
    this.$body[0].removeChild(scrollDiv)
    return scrollbarWidth
  }


  // MODAL PLUGIN DEFINITION
  // =======================

  function Plugin(option, _relatedTarget) {
    return this.each(function () {
      var $this   = $(this)
      var data    = $this.data('bs.modal')
      var options = $.extend({}, Modal.DEFAULTS, $this.data(), typeof option == 'object' && option)

      if (!data) $this.data('bs.modal', (data = new Modal(this, options)))
      if (typeof option == 'string') data[option](_relatedTarget)
      else if (options.show) data.show(_relatedTarget)
    })
  }

  var old = $.fn.modal

  $.fn.modal             = Plugin
  $.fn.modal.Constructor = Modal


  // MODAL NO CONFLICT
  // =================

  $.fn.modal.noConflict = function () {
    $.fn.modal = old
    return this
  }


  // MODAL DATA-API
  // ==============

  $(document).on('click.bs.modal.data-api', '[data-toggle="modal"]', function (e) {
    var $this   = $(this)
    var href    = $this.attr('href')
    var $target = $($this.attr('data-target') || (href && href.replace(/.*(?=#[^\s]+$)/, ''))) // strip for ie7
    var option  = $target.data('bs.modal') ? 'toggle' : $.extend({ remote: !/#/.test(href) && href }, $target.data(), $this.data())

    if ($this.is('a')) e.preventDefault()

    $target.one('show.bs.modal', function (showEvent) {
      if (showEvent.isDefaultPrevented()) return // only register focus restorer if modal will actually get shown
      $target.one('hidden.bs.modal', function () {
        $this.is(':visible') && $this.trigger('focus')
      })
    })
    Plugin.call($target, option, this)
  })

}(jQuery);

var updateExpBar = function(topic_bar_id) {
    if (typeof topic_bar_id === 'undefined') {
      topic_bar_id = '.topic-bar';
    }
    // console.log(topic_bar_id);
    $(topic_bar_id).each(function() {
      div_width = this.dataset.progress;
      // console.log($(this).is('visible'));
      // console.log($(this));
      if ($(this).is(':visible')) {
          $(this).velocity({ width: div_width }, 2500, 'easeOutSine')
      }
    })
}

var updateModalBar = function(current_exp, new_exp) {
  div_width = document.getElementById('new-exp').dataset.progress

  $('.modal-new-exp-bar').velocity({ width: div_width }, 2500, 'easeOutSine', {
      complete: setTimeout(function(){
        $('#new-exp').css('background-color', '#44AF69')
      }, 3000)
    })
  setTimeout(function() {
    jQuery({ Counter: current_exp }).animate({ Counter: new_exp }, {
      duration: 2500,
      easing: 'swing',
      step: function () {
        $('#modal-exp-text').text(Math.ceil(this.Counter));
      }
    });
  }, 500);
}
