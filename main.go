package main

import (
	"github.com/gin-gonic/gin"
	"log"
	"mrmapping.com/mrmapping/config"
	"mrmapping.com/mrmapping/database"
	"mrmapping.com/mrmapping/routers"
	"mrmapping.com/mrmapping/ws"
	"os"
)

func main() {
	// 環境変数の読み込み
	config.LoadConfig()

	// データベースの初期化
	database.InitDB()

	// Ginのデフォルトのルーターを作成
	r := gin.Default()

	// ルーティングの設定
	routers.SetupRouter(r)

	// ポート番号の取得
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080" // デフォルトのポート番号
	}

	// WebSocketサーバーの起動
	go func() {
		err := ws.Run(port)
		if err != nil {
			log.Fatal("Failed to start WebSocket server: ", err)
		}
		log.Println("WebSocket server started on /ws")
	}()

	// HTTPサーバーの起動をログに記録
	log.Printf("HTTP server started on port %s", port)

	// HTTPサーバーを起動
	if err := r.Run(":" + port); err != nil {
		log.Fatal("Failed to start HTTP server: ", err)
	}
}
