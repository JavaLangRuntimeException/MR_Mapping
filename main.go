package main

import (
	"log"
	"net/http"
	"os"
	"sync"

	"github.com/googollee/go-socket.io"
)

var server *socketio.Server

func init() {
	server = socketio.NewServer(nil)
}

// Messageの型を作る
type Message struct {
	ID1 int `json:"id1"`
	ID2 int `json:"id2"`
}

// Client represents a single WebSocket connection
type Client struct {
	conn socketio.Conn
}

// ClientManager manages all active WebSocket connections
type ClientManager struct {
	clients    map[*Client]bool
	broadcast  chan Message
	register   chan *Client
	unregister chan *Client
	mu         sync.Mutex
}

// NewClientManager creates a new ClientManager
func NewClientManager() *ClientManager {
	return &ClientManager{
		clients:    make(map[*Client]bool),
		broadcast:  make(chan Message),
		register:   make(chan *Client),
		unregister: make(chan *Client),
	}
}

// Start runs the client manager
func (manager *ClientManager) Start() {
	for {
		select {
		case client := <-manager.register:
			manager.mu.Lock()
			manager.clients[client] = true
			manager.mu.Unlock()
		case client := <-manager.unregister:
			manager.mu.Lock()
			if _, ok := manager.clients[client]; ok {
				delete(manager.clients, client)
				client.conn.Close()
			}
			manager.mu.Unlock()
		case message := <-manager.broadcast:
			manager.mu.Lock()
			for client := range manager.clients {
				client.conn.Emit("data received", message)
			}
			manager.mu.Unlock()
		}
	}
}

var manager = NewClientManager()

func main() {
	go manager.Start()

	server.OnConnect("/", func(s socketio.Conn) error {
		client := &Client{conn: s}
		manager.register <- client

		s.SetContext("")

		log.Println("connected:", s.ID())

		return nil
	})

	server.OnEvent("/", "send data", func(s socketio.Conn, msg Message) {
		log.Printf("recv: %+v", msg)
		manager.broadcast <- msg
	})

	server.OnError("/", func(s socketio.Conn, e error) {
		log.Println("error:", e)
	})

	server.OnDisconnect("/", func(s socketio.Conn, reason string) {
		log.Println("closed", reason)
		client := &Client{conn: s}
		manager.unregister <- client
	})

	go server.Serve()
	defer server.Close()

	http.Handle("/socket.io/", server)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	log.Println("Starting server on :" + port)
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		log.Fatal(err)
	}
}
