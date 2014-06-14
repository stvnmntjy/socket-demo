sockets = []
###
{
  action: '' (start, close)
  payload: '' (symbol, null)
}
###
onmessage = (ev) ->
  console.log 'received message from spawner!'
  if ev.data.action is 'start'
    sockets.push createStockSocket ev.data.payload
  else if ev.data.action is 'close'
    socket.close() for socket in sockets
    sockets = []
  return

createStockSocket = (symbol) ->
  socket = new WebSocket 'ws://localhost:3000/websocket'
  socket.onopen = (ev) ->
    console.log 'socket connection established'
    @send symbol
    return
  socket.onmessage = (ev) ->
    postMessage ev.data
    return
  socket.onclose = (ev) ->
    console.log 'closing'
    @close()
    return
  socket
