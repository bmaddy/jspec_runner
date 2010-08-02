SpecLoader = {
  // executing: function(file){
  //   console.log('executing ' + file)
  //   if (file.match(/matchers/))
  //     return 'stop'
  // },
  loading: function(file){
    // making a quick one-time stub
    var stubbed = JSpec.xhr
    JSpec.xhr = function(){
      JSpec.xhr = stubbed
      return {
        open: function(){ return true },
        send: function(){ return true },
        readyState: 4,
        status: 0,
        responseText: Ruby.JSpecRunner.XhrProxy.specRequest(file)
      }
    }
  }
}
JSpec.include(SpecLoader)
