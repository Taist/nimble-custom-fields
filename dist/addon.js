function init(){var require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
module.exports = {};

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
var api;

api = require('../globals/api');

module.exports = function(groupingCondition) {
  var selector;
  api.log('Hello world ' + groupingCondition);
  selector = '.listHeader .gwt-ListBox';
  return api.wait.elementRender(selector, function(element) {
    var groupingList;
    if (!$('option[value="industry"]', element).size()) {
      groupingList = element[0];
      $('<option value="industry">').text('Industry').appendTo(groupingList);
      return groupingList.addEventListener('change', function() {
        return api.log(this.value);
      });
    }
  });
};

},{"../globals/api":1}],"addon":[function(require,module,exports){
var addonEntry, api;

api = require('./globals/api');

addonEntry = {
  start: function(_taistApi, entryPoint) {
    var onChangeHash;
    $.extend(api, _taistApi);
    onChangeHash = require('./handlers/onChangeHash');
    return _taistApi.hash.onChange(onChangeHash);
  }
};

module.exports = addonEntry;

},{"./globals/api":1,"./handlers/onChangeHash":2}]},{},[]);
;return require("addon")}
//Just a sample of concat task
