package main

import (
	"github.com/gin-gonic/gin"
	"log"
	"mrmapping.com/mrmapping/config"
	"mrmapping.com/mrmapping/database"
	"mrmapping.com/mrmapping/routers"
	"mrmapping.com/mrmapping/ws"
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

	// サーバーをポート8000で起動
	r.Run(":8080")

	// サーバーの起動をログに記録
	log.Println("Server started ")

	ws.Run()
	log.Println("Websocket started ")
}
