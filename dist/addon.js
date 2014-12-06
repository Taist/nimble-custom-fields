function init(){var require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
module.exports = {
  options: {
    nimbleToken: '',
    dealsPerPage: 2
  },
  data: {
    deals: {}
  }
};

},{}],2:[function(require,module,exports){
module.exports = function(cur, old) {
  var dealListPattern, groupingCondition, hash, matches;
  hash = location.hash;
  dealListPattern = /app\/deals\/list/;
  if (cur != null ? cur.match(dealListPattern) : void 0) {
    matches = cur.match(/grouped_by=([^&]+)/);
    groupingCondition = (matches != null ? matches[1] : void 0) || 'none';
    if (groupingCondition === 'industry' || !(old != null ? old.match(dealListPattern) : void 0)) {
      return require('../handlers/onOpenDealsList')(groupingCondition);
    }
  }
};

},{"../handlers/onOpenDealsList":3}],3:[function(require,module,exports){
var app, isLoadingInProgress, loadDeals, processDeals;

app = require('../app');

isLoadingInProgress = false;

loadDeals = function(page) {
  if (page == null) {
    page = 1;
  }
  return $.ajax({
    url: '/api/deals',
    dataType: "json",
    headers: {
      Authorization: "Nimble token=\"" + app.options.nimbleToken + "\""
    },
    data: {
      sort_by: 'age',
      dir: 'asc',
      page: page,
      per_page: app.options.dealsPerPage
    },
    success: function(data) {
      var meta;
      processDeals(data);
      meta = data.meta;
      if (meta.has_more) {
        return loadDeals(meta.page + 1);
      } else {
        return isLoadingInProgress = false;
      }
    }
  });
};

processDeals = function(deals) {
  return deals.resources.forEach(function(deal) {
    app.api.log(deal);
    return app.data.deals[deal.id] = deal;
  });
};

module.exports = function(groupingCondition) {
  var selector;
  app.api.log('Hello world', groupingCondition);
  selector = '.listHeader .gwt-ListBox';
  return app.api.wait.elementRender(selector, function(element) {
    var groupingList;
    if (!$('option[value="industry"]', element).size()) {
      groupingList = element[0];
      $('<option value="industry">').text('Industry').appendTo(groupingList);
      groupingList.addEventListener('change', function() {
        return app.api.log(this.value);
      });
    }
    if (groupingCondition === 'industry') {
      if (!isLoadingInProgress) {
        isLoadingInProgress = true;
        return loadDeals();
      }
    }
  });
};

},{"../app":1}],4:[function(require,module,exports){
module.exports = {
  registerHandler: function(responseHandler) {
    var XMLHttpRequestSend;
    XMLHttpRequestSend = XMLHttpRequest.prototype.send;
    return XMLHttpRequest.prototype.send = function() {
      var onReady, self;
      onReady = this.onreadystatechange;
      self = this;
      this.onreadystatechange = function() {
        if (self.readyState === 4) {
          responseHandler(self);
        }
        onReady && onReady.apply(self, arguments);
      };
      XMLHttpRequestSend.apply(this, arguments);
    };
  }
};

},{}],"addon":[function(require,module,exports){
var addonEntry, app;

app = require('./app');

addonEntry = {
  start: function(_taistApi, entryPoint) {
    var onChangeHash, proxy;
    window.app = app;
    app.api = _taistApi;
    proxy = require('./tools/xmlHttpProxy');
    proxy.registerHandler(function(request) {
      var matches, url;
      url = request.responseURL;
      matches = url.match(/\/api\/sessions\/([0-9abcdef-]{36})\?/);
      if (matches) {
        return app.options.nimbleToken = matches[1];
      }
    });
    onChangeHash = require('./handlers/onChangeHash');
    return _taistApi.hash.onChange(onChangeHash);
  }
};

module.exports = addonEntry;

},{"./app":1,"./handlers/onChangeHash":2,"./tools/xmlHttpProxy":4}]},{},[]);
;return require("addon")}
//Just a sample of concat task
