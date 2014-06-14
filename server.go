package main

import (
	"net/http"

	"github.com/eknkc/amber"
	"github.com/go-martini/martini"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

func main() {
	m := martini.Classic()
	m.Get("/", rootHandler)
	m.Get("/websocket", socketHandler)
	m.Run()
}

func rootHandler(w http.ResponseWriter, r *http.Request) {
	compiler := amber.New()
	e := compiler.ParseFile("./templates/index.amber")
	if e != nil {
		http.Error(w, e.Error(), http.StatusInternalServerError)
		return
	}
	tpl, e := compiler.Compile()
	if e != nil {
		http.Error(w, e.Error(), http.StatusInternalServerError)
		return
	}
	e = tpl.Execute(w, nil)
	if e != nil {
		http.Error(w, e.Error(), http.StatusInternalServerError)
		return
	}
}

func socketHandler(w http.ResponseWriter, r *http.Request) {
	conn, e := upgrader.Upgrade(w, r, w.Header())
	if e != nil {
		http.Error(w, e.Error(), http.StatusUnsupportedMediaType)
		return
	}
	defer conn.Close()
	_, p, e := conn.ReadMessage()
	if e != nil {
		http.Error(w, e.Error(), http.StatusBadRequest)
		return
	}
	conn.WriteMessage(websocket.TextMessage, p)
}
