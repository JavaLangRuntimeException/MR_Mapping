package main

import (
	"context"
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
	redisURL := "redis://:p06d882614e06cb8d50cc7a26ac8d9f938cb6f494037e264d8c759b7d56acb589@ec2-3-211-177-74.compute-1.amazonaws.com:25949"
	opt, _ := redis.ParseURL(redisURL)
	rdb = redis.NewClient(opt)

	r.GET("/ws", func(c *gin.Context) {
		conn, _ := upgrader.Upgrade(c.Writer, c.Request, nil)
		defer conn.Close()

		for {
			messageType, p, err := conn.ReadMessage()
			if err != nil {
				return
			}

			println(string(p))

			// 受信したメッセージをRedisに保存
			err = rdb.Set(context.Background(), "message", p, 0).Err()
			if err != nil {
				panic(err)
			}

			// Redisから最新のメッセージを取得
			val, err := rdb.Get(context.Background(), "message").Result()
			if err != nil {
				panic(err)
			}
			println("Message from Redis:", val)

			if err := conn.WriteMessage(messageType, p); err != nil {
				return
			}
		}
	})

	r.Run(":8080")
}
