MyModule = {
  executing : function(file) {
    if (file.match(/matchers/))
      document.body.innerHTML = "STOP!"
      return 'stop'
  }
}
JSpec.include(MyModule)
