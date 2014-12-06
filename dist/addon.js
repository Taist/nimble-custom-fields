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
    $('.dealListByIndustry').hide();
    if (groupingCondition === 'industry' || !(old != null ? old.match(dealListPattern) : void 0)) {
      return require('../handlers/onOpenDealsList')(groupingCondition);
    }
  }
};

},{"../handlers/onOpenDealsList":3}],3:[function(require,module,exports){
var app, isLoadingInProgress, loadDeals, processDeals, renderDealList;

app = require('../app');

isLoadingInProgress = false;

renderDealList = function() {
  var container, simpleList;
  $('.groupGlobalHeader').parent().hide();
  $('.emptyView').hide();
  simpleList = $('.dealList');
  simpleList.parent().hide();
  container = $('.dealListByIndustry');
  if (!container.size()) {
    container = $('<div class="dealListByIndustry">');
    container.insertBefore(simpleList.parent());
  }
  container.empty().show();
  return container.append(require('../interface/dealListWithGroups'));
};

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
        isLoadingInProgress = false;
        return renderDealList();
      }
    }
  });
};

processDeals = function(deals) {
  return deals.resources.forEach(function(deal) {
    var category;
    category = parseInt(deal.id[23], 16) % 2;
    deal.industry = (function() {
      switch (category) {
        case 1:
          return 'Food';
        default:
          return 'IT';
      }
    })();
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
      if (groupingCondition === 'industry') {
        $(groupingList).val('industry');
      }
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

},{"../app":1,"../interface/dealListWithGroups":4}],4:[function(require,module,exports){
var dealList;

dealList = '<div> <table class="groupGlobalHeader"> <colgroup> <col> </colgroup> <tbody> <tr> <td class="headerTD c0 subject" sorting_param="subject">Deal name</td> <td class="headerTD c1 related_primary" sorting_param="related_primary">Company or Person</td> <td class="headerTD c2 amount" sorting_param="amount">Amount</td> <td class="headerTD c3 stage" sorting_param="stage">Stage</td> <td class="headerTD c4 probability" sorting_param="probability">Probability</td> <td class="headerTD c5 expected_close" sorting_param="expected_close">Expected</td> <td class="headerTD c6 age" sorting_param="age">Age (days)</td> </tr> </tbody> </table> <div class="GroupDealListWidget"> <table class="groupHeader"> <colgroup> <col> </colgroup> <tbody> <tr class="total"> <td class="c0"><a class="btnExpand plus">Needs Analysis</a> </td> <td class="c1"> </td> <td class="c2">$ 500</td> <td class="c3"> </td> <td class="c4"> </td> <td class="c5"> </td> <td class="c6">1</td> </tr> <tr class="weightedAmount"> <td class="c0"> <div class="gwt-HTML"></div> </td> <td class="c1">Weighted:</td> <td class="c2">$ 300</td> <td class="c3"> </td> <td class="c4"> </td> <td class="c5"> </td> <td class="c6"> </td> </tr> </tbody> </table> <div class="dealList" aria-hidden="true" style="display: none;"> <table class="header" aria-hidden="true" style="display: none;"> <colgroup> <col> </colgroup> <tbody> <tr> <td class="headerTD c0 subject" sorting_param="subject">Deal name</td> <td class="headerTD c1 related_primary" sorting_param="related_primary">Company or Person</td> <td class="headerTD c2 amount" sorting_param="amount">Amount</td> <td class="headerTD c3 stage" sorting_param="stage">Stage</td> <td class="headerTD c4 probability" sorting_param="probability">Probability</td> <td class="headerTD c5 expected_close sort" sorting_param="expected_close">Expected<span class="asc">&nbsp; </span> </td> <td class="headerTD c6 age" sorting_param="age">Age (days)</td> </tr> </tbody> </table> <div class="body"> <table> <tbody> <tr class="row_54806f49faed294a074e258d" groupname="Needs Analysis"> <td class="cell c0"><a href="#app/deals/view?id=54806f49faed294a074e258d" target="_blank" class="deal_subject">Another sample</a> </td> <td class="cell c1"><a href="#app/contacts/view?id=54806a9d4429cf0756007fac">Alexander Temerev</a> </td> <td class="cell c2">$ 500</td> <td class="cell c3"><span class="name">Needs Analysis</span><span class="days_in_stage">1 day</span> </td> <td class="cell c4">60%</td> <td class="cell c5">Dec 4, 2014</td> <td class="cell c6">1</td> </tr> </tbody> </table> </div> <div aria-hidden="true" class="nmbl-Pagination" style="display: none;"> <table cellspacing="0" cellpadding="0" class="standartContainer" aria-hidden="true" style="display: none;"> <tbody> <tr></tr> </tbody> </table> <div class="moreContainer" aria-hidden="true" style="display: none;"><a class="showMore" href="javascript:;">Show More</a> </div> </div> <div class="totalBlock"> <table class="totalTable"> <tbody> <tr class="totalRow"> <td class="total c0">Needs Analysis Total:</td> <td class="total c1"></td> <td class="total c2">$ 500</td> <td class="total c3"></td> <td class="total c4"></td> <td class="total c5"></td> <td class="total c6">1*</td> </tr> <tr class="weightedRow"> <td class="total c0"></td> <td class="total c1">Weighted:</td> <td class="total c2 weighted">$ 300</td> <td class="total c3"></td> <td class="total c4"></td> <td class="total c5"></td> <td class="total c6"></td> </tr> </tbody> </table> </div> </div> </div> <div class="GroupDealListWidget last"> <table class="groupHeader"> <colgroup> <col> </colgroup> <tbody> <tr class="total"> <td class="c0"><a class="btnExpand plus">Qualification</a> </td> <td class="c1"> </td> <td class="c2">$ 2,240</td> <td class="c3"> </td> <td class="c4"> </td> <td class="c5"> </td> <td class="c6">1</td> </tr> <tr class="weightedAmount"> <td class="c0"> <div class="gwt-HTML"></div> </td> <td class="c1">Weighted:</td> <td class="c2">$ 1,792</td> <td class="c3"> </td> <td class="c4"> </td> <td class="c5"> </td> <td class="c6"> </td> </tr> </tbody> </table> <div class="dealList" aria-hidden="true" style="display: none;"> <table class="header" aria-hidden="true" style="display: none;"> <colgroup> <col> </colgroup> <tbody> <tr> <td class="headerTD c0 subject" sorting_param="subject">Deal name</td> <td class="headerTD c1 related_primary" sorting_param="related_primary">Company or Person</td> <td class="headerTD c2 amount" sorting_param="amount">Amount</td> <td class="headerTD c3 stage" sorting_param="stage">Stage</td> <td class="headerTD c4 probability" sorting_param="probability">Probability</td> <td class="headerTD c5 expected_close sort" sorting_param="expected_close">Expected<span class="asc">&nbsp; </span> </td> <td class="headerTD c6 age" sorting_param="age">Age (days)</td> </tr> </tbody> </table> <div class="body"> <table> <tbody> <tr class="row_548074ccae31560f7369abd2" groupname="Qualification"> <td class="cell c0"><a href="#app/deals/view?id=548074ccae31560f7369abd2" target="_blank" class="deal_subject">Deal 17:40</a> </td> <td class="cell c1"><a href="#app/contacts/view?id=54806a9f4429cf0756008049">Shayna Hogg</a> </td> <td class="cell c2">$ 1,740</td> <td class="cell c3"><span class="name">Qualification</span><span class="days_in_stage">1 day</span> </td> <td class="cell c4">80%</td> <td class="cell c5">Dec 4, 2014</td> <td class="cell c6">1</td> </tr> <tr class="row_548069e7faed292012036dc7" groupname="Qualification"> <td class="cell c0"><a href="#app/deals/view?id=548069e7faed292012036dc7" target="_blank" class="deal_subject">Sample Deal</a> </td> <td class="cell c1"><a href="#app/contacts/view?id=548069e7faed292012036db2">Jon Ferrara</a> </td> <td class="cell c2">$ 500</td> <td class="cell c3"><span class="name">Qualification</span><span class="days_in_stage">1 day</span> </td> <td class="cell c4">80%</td> <td class="cell c5">Dec 4, 2014</td> <td class="cell c6">1</td> </tr> </tbody> </table> </div> <div aria-hidden="true" class="nmbl-Pagination" style="display: none;"> <table cellspacing="0" cellpadding="0" class="standartContainer" aria-hidden="true" style="display: none;"> <tbody> <tr></tr> </tbody> </table> <div class="moreContainer" aria-hidden="true" style="display: none;"><a class="showMore" href="javascript:;">Show More</a> </div> </div> <div class="totalBlock"> <table class="totalTable"> <tbody> <tr class="totalRow"> <td class="total c0">Qualification Total:</td> <td class="total c1"></td> <td class="total c2">$ 2,240</td> <td class="total c3"></td> <td class="total c4"></td> <td class="total c5"></td> <td class="total c6">1*</td> </tr> <tr class="weightedRow"> <td class="total c0"></td> <td class="total c1">Weighted:</td> <td class="total c2 weighted">$ 1,792</td> <td class="total c3"></td> <td class="total c4"></td> <td class="total c5"></td> <td class="total c6"></td> </tr> </tbody> </table> </div> </div> </div> <div class="descriptionTotal">*Average age on total line</div> </div>';

module.exports = dealList;

},{}],5:[function(require,module,exports){
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

},{"./app":1,"./handlers/onChangeHash":2,"./tools/xmlHttpProxy":5}]},{},[]);
;return require("addon")}
//Just a sample of concat task
