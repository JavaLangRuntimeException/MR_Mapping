package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"sync"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

// Message represents the structure of a message
type Message struct {
	ID1 int `json:"id1"`
	ID2 int `json:"id2"`
}

// Client represents a single WebSocket connection
type Client struct {
	conn *websocket.Conn
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
				err := client.conn.WriteJSON(message)
				if err != nil {
					log.Printf("error: %v", err)
					client.conn.Close()
					delete(manager.clients, client)
				}
			}
			manager.mu.Unlock()
		}
	}
}

var manager = NewClientManager()

func wsHandler(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}
	client := &Client{conn: conn}
	manager.register <- client

	defer func() {
		manager.unregister <- client
	}()

	for {
		var msg Message
		err := conn.ReadJSON(&msg)
		if err != nil {
			log.Println("read:", err)
			break
		}

		log.Printf("Received message: %+v", msg)

		// Process the received message
		processedMsg := fmt.Sprintf("Data processed: id1=%d, id2=%d", msg.ID1, msg.ID2)

		// Send the processed message back to the client
		err = conn.WriteMessage(websocket.TextMessage, []byte(processedMsg))
		if err != nil {
			log.Println("write:", err)
			break
		}
	}
}

func main() {
	go manager.Start()

	port := os.Getenv("PORT")
	if port == "" {
		port = "8000"
	}
	http.HandleFunc("/ws", wsHandler)
	log.Println("Starting server on :" + port)
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		log.Fatal(err)
	}
}
