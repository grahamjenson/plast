inject = (func) ->
  actualCode = '(' + func + ')();'
  script = document.createElement('script');
  script.textContent = actualCode;
  (document.head||document.documentElement).appendChild(script);
  script.parentNode.removeChild(script);

chrome.extension.onMessage.addListener((request, sender, sendResponse) ->
  if request.type == "plysit_plugin"
    if request.ytitem
      s = JSON.stringify(request.ytitem)
      func = ["function(){window.global_pl.add_yt_item(#{s});}"].join("\n")
      inject(func)
)
