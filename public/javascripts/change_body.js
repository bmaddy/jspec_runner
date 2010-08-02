var change_body = function(context){
  $('p', context).html("body changed by change_body.js")
}
var change_body_xhr = function(context){
  $.get('xhr', function(response){
    $('p', context).html("body changed by " + response)
  })
}
