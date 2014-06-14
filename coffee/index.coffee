worker = new Worker './js/stockworker.js'

worker.onmessage = (ev) ->
  alert "received: #{ev.data} from worker"
  worker.postMessage
    action: 'close'
    payload: null
  return

worker.postMessage
  action: 'start'
  payload: 'GOOG'


