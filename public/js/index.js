// Generated by CoffeeScript 1.7.1
var bloodHound, worker;

bloodHound = new Bloodhound({
  datumTokenizer: function(d) {
    return Bloodhound.tokenizers.whitespace(d.val);
  },
  dupDetector: function(remote, local) {
    return remote.Symbol === local.Symbol && remote.Name === local.Name && remote.Exchange === local.Exchange;
  },
  local: [],
  name: 'stockSymbols',
  prefetch: {
    ajax: {
      crossDomain: true,
      dataType: 'jsonp',
      success: function(json) {
        console.dir(bloodHound);
      }
    },
    filter: function(arr) {
      return arr;
    },
    url: 'http://dev.markitondemand.com/api/v2/Lookup/jsonp?input=%QUERY'
  },
  queryTokenizer: Bloodhound.tokenizers.whitespace,
  remote: {
    ajax: {
      crossDomain: true,
      dataType: 'jsonp',
      success: function(json) {
        console.dir(bloodHound);
      }
    },
    filter: function(arr) {
      return arr;
    },
    url: 'http://dev.markitondemand.com/api/v2/Lookup/jsonp?input=%QUERY'
  }
});

bloodHound.initialize();

$('#symbol-search').typeahead(null, {
  name: 'stockSymbols',
  source: bloodHound.ttAdapter(),
  templates: {
    suggestion: Handlebars.compile('<p><strong>{{Symbol}}</strong> {{Name}} {{Exchange}}</p>')
  }
});

worker = new Worker('./js/stockworker.js');

worker.onmessage = function(ev) {
  console.dir(JSON.parse(ev.data));
  worker.postMessage({
    action: 'close',
    payload: null
  });
};

worker.postMessage({
  action: 'start',
  payload: 'GOOGL'
});
