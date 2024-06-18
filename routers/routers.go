package routers

import (
	"github.com/gin-gonic/gin"
	"mrmapping.com/mrmapping/controllers"
)

// ルーティングを設定
func SetupRouter(r *gin.Engine) {

	r.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{"message": "connected"})
	})

	// GETリクエストでのユーザー取得エンドポイントを設定し、controllers.GetUsers関数を実行する
	r.GET("/rooms/", controllers.GetRooms)

	// GETリクエストでの特定のユーザー取得エンドポイントを設定し、controllers.GetUser関数を実行する
	r.GET("/rooms/:id/", controllers.GetRoom)

}
