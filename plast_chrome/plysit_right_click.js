(function() {
  var PlysitPlugin;

  PlysitPlugin = (function() {

    function PlysitPlugin() {
      var _this = this;
      chrome.tabs.onCreated.addListener(function() {
        return _this.createContextMenu();
      });
      chrome.tabs.onRemoved.addListener(function() {
        return _this.createContextMenu();
      });
      chrome.tabs.onUpdated.addListener(function() {
        return _this.createContextMenu();
      });
    }

    PlysitPlugin.prototype.plysit_url = function(url) {
      return /.*:\/\/.*plysit.com\/playlist\/.*/.test(url);
    };

    PlysitPlugin.prototype.targetPatterns = ['*://*.youtube.com/watch?v=*', '*://*.youtu.be/*'];

    PlysitPlugin.prototype.createContextMenu = function() {
      var __this,
        _this = this;
      chrome.contextMenus.removeAll();
      chrome.contextMenus.create({
        title: "Add to new Plysit",
        contexts: ["link"],
        targetUrlPatterns: this.targetPatterns,
        onclick: function(info) {
          return _this.createNewPlysit(info.linkUrl);
        }
      });
      __this = this;
      return this.forEachTab(function(t) {
        if (_this.plysit_url(t.url)) {
          return chrome.contextMenus.create({
            title: "Add to " + t.url,
            contexts: ["link"],
            targetUrlPatterns: _this.targetPatterns,
            onclick: function(info) {
              return __this.addToPlysit(t.url, info.linkUrl);
            }
          });
        }
      });
    };

    PlysitPlugin.prototype.youtube_parser = function(url) {
      var match, regExp;
      regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/;
      match = url.match(regExp);
      if (match && match[7].length === 11) {
        return match[7];
      } else {
        return null;
      }
    };

    PlysitPlugin.prototype.createNewPlysit = function(yturl) {
      var ytid;
      ytid = this.youtube_parser(yturl);
      if (ytid) {
        return $.getJSON("https://gdata.youtube.com/feeds/api/videos/" + ytid + "?alt=jsonc&v=2", function(d) {
          return console.log(d);
        });
      }
    };

    PlysitPlugin.prototype.addToPlysit = function(plyurl, yturl) {
      console.log(yturl);
      return console.log(this.youtube_parser(yturl));
    };

    PlysitPlugin.prototype.forEachTab = function(fun) {
      return chrome.windows.getAll(function(w) {
        var win, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = w.length; _i < _len; _i++) {
          win = w[_i];
          _results.push(chrome.tabs.getAllInWindow(win.id, function(tabs) {
            var t, _j, _len2, _results2;
            _results2 = [];
            for (_j = 0, _len2 = tabs.length; _j < _len2; _j++) {
              t = tabs[_j];
              _results2.push(fun(t));
            }
            return _results2;
          }));
        }
        return _results;
      });
    };

    return PlysitPlugin;

  })();

  window.plysit_plugin = new PlysitPlugin();

  window.plysit_plugin.createContextMenu();

}).call(this);
