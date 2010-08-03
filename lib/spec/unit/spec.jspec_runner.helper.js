SpecLoader = {
  loading: function(file){
    // making a quick one-time stub
    var stubbed = JSpec.xhr
    JSpec.xhr = function(){
      // only stub this for one call
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
