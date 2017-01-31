function init_icheck(){
  if($(".icheck-me").length > 0){
    $(".icheck-me").each(function(){
      var $el = $(this);
      var skin = ($el.attr('data-skin') !== undefined) ? "_" + $el.attr('data-skin') : "",
      color = ($el.attr('data-color') !== undefined) ? "-" + $el.attr('data-color') : "";
      var opt = {
        radioClass: 'iradio' + skin + color,
        increaseArea: '20%' // optional
      }
      $el.iCheck(opt);
    });
  }
}

$(function(){
  init_icheck();
})
