package services

import (
	"mrmapping.com/mrmapping/models"
	"mrmapping.com/mrmapping/repositories"
)

// すべてのユーザーを取得
func GetRooms() ([]models.Room, error) {
	return repositories.GetAllRooms()
}

// 指定されたIDのユーザーを取得
func GetRoom(id string) (models.Room, error) {
	return repositories.GetRoom(id)
}
