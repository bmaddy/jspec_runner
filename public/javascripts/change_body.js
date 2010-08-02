// probably need to do this on document ready
// document.body.innerHTML = "body changed by change_body.js"
var change_body = function(context){
  $('p', context).html("body changed by change_body.js")
}
