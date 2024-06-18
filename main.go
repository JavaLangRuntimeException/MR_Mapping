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

	go func() {
		ws.Run()
		log.Println("Websocket started")
	}()

	// サーバーの起動をログに記録
	log.Printf("Server started on port %s", port)

	// サーバーを起動
	if err := r.Run(":" + port); err != nil {
		log.Fatal(err)
	}
}
