package controllers

import (
	"github.com/gin-gonic/gin"
	"mrmapping.com/mrmapping/services"
	"net/http"
)

// 全てのユーザーデータの取得
func GetRooms(c *gin.Context) {
	Rooms, err := services.GetRooms()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, Rooms)
}

// 指定されたIDのユーザーデータの取得
func GetRoom(c *gin.Context) {
	id := c.Param("id")
	Room, err := services.GetRoom(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, Room)
}
