package ws

import (
	"context"
	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis/v8"
	"github.com/gorilla/websocket"
	"log"
	"os"
	"sync"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

var rdb *redis.Client
var connectedClients = make(map[*websocket.Conn]bool)
var clientsMutex sync.Mutex

func Run() {
	r := gin.Default()

	// RedisのURLを環境変数から取得
	redisURL := os.Getenv("REDIS_URL")
	if redisURL == "" {
		redisURL = "redis://:p06d882614e06cb8d50cc7a26ac8d9f938cb6f494037e264d8c759b7d56acb589@ec2-3-211-177-74.compute-1.amazonaws.com:25949"
	}
	opt, err := redis.ParseURL(redisURL)
	if err != nil {
		panic(err)
	}
	rdb = redis.NewClient(opt)

	r.GET("/ws", func(c *gin.Context) {
		conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
		if err != nil {
			log.Println("Failed to upgrade connection:", err)
			return
		}
		defer func() {
			clientsMutex.Lock()
			delete(connectedClients, conn)
			clientsMutex.Unlock()
			conn.Close()
		}()

		clientsMutex.Lock()
		connectedClients[conn] = true
		clientsMutex.Unlock()

		for {
			messageType, p, err := conn.ReadMessage()
			if err != nil {
				log.Println("Failed to read message:", err)
				return
			}

			println(string(p))

			// 受信したメッセージをRedisに保存
			err = rdb.Set(context.Background(), "message", p, 0).Err()
			if err != nil {
				log.Println("Failed to save message to Redis:", err)
				if err := conn.WriteMessage(websocket.TextMessage, []byte("Failed to save message to Redis")); err != nil {
					log.Println("Failed to write message:", err)
				}
				return
			}

			// 受信したメッセージをすべての接続中のクライアントにブロードキャスト
			clientsMutex.Lock()
			for client := range connectedClients {
				if err := client.WriteMessage(messageType, p); err != nil {
					log.Println("Failed to write message:", err)
					delete(connectedClients, client)
				}
			}
			clientsMutex.Unlock()
		}
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	r.Run(":" + port)
}
