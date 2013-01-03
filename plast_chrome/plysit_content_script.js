(function() {
  var inject;

  inject = function(func) {
    var actualCode, script;
    actualCode = '(' + func + ')();';
    script = document.createElement('script');
    script.textContent = actualCode;
    (document.head || document.documentElement).appendChild(script);
    return script.parentNode.removeChild(script);
  };

  chrome.extension.onMessage.addListener(function(request, sender, sendResponse) {
    var func, s;
    if (request.type === "plysit_plugin") {
      if (request.ytitem) {
        s = JSON.stringify(request.ytitem);
        func = ["function(){window.global_pl.add_search_item(" + s + ");}"].join("\n");
        return inject(func);
      }
    }
  });

}).call(this);
