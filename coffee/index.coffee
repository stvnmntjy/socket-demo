bloodHound = new Bloodhound
  datumTokenizer: (d) -> Bloodhound.tokenizers.whitespace d.val
  dupDetector: (remote, local) -> remote.Symbol is local.Symbol and remote.Name is local.Name and remote.Exchange is local.Exchange
  local: []
  name: 'stockSymbols'
  prefetch:
    ajax:
      crossDomain: true
      dataType: 'jsonp'
      success: (json) ->
        console.dir bloodHound
        return
    filter: (arr) -> arr
    url: 'http://dev.markitondemand.com/api/v2/Lookup/jsonp?input=%QUERY'
  queryTokenizer: Bloodhound.tokenizers.whitespace
  remote:
    ajax:
      crossDomain: true
      dataType: 'jsonp'
      success: (json) ->
        console.dir bloodHound
        return
    filter: (arr) -> arr
    url: 'http://dev.markitondemand.com/api/v2/Lookup/jsonp?input=%QUERY'

bloodHound.initialize()

$('#symbol-search').typeahead null,
  name: 'stockSymbols'
  source: bloodHound.ttAdapter(),
  templates:
    suggestion: Handlebars.compile '<p><strong>{{Symbol}}</strong> {{Name}} {{Exchange}}</p>'

worker = new Worker './js/stockworker.js'

worker.onmessage = (ev) ->
  console.dir JSON.parse ev.data
  worker.postMessage
    action: 'close'
    payload: null
  return

worker.postMessage
  action: 'start'
  payload: 'GOOGL'


