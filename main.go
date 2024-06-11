package main

import (
	"context"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis/v8"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

var rdb *redis.Client

func main() {
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
			c.String(400, "Failed to upgrade connection")
			return
		}
		defer conn.Close()

		for {
			messageType, p, err := conn.ReadMessage()
			if err != nil {
				c.String(400, "Failed to read message")
				return
			}

			println(string(p))

			// 受信したメッセージをRedisに保存
			err = rdb.Set(context.Background(), "message", p, 0).Err()
			if err != nil {
				c.String(500, "Failed to save message to Redis")
				return
			}

			// Redisから最新のメッセージを取得
			val, err := rdb.Get(context.Background(), "message").Result()
			if err != nil {
				c.String(500, "Failed to get message from Redis")
				return
			}
			println("Message from Redis:", val)

			if err := conn.WriteMessage(messageType, p); err != nil {
				c.String(500, "Failed to write message")
				return
			}
		}
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	r.Run(":" + port)
}
