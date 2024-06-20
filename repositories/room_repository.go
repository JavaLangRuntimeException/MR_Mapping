package repositories

import (
	"context"
	"mrmapping.com/mrmapping/database"
	"mrmapping.com/mrmapping/models"
)

// すべてのユーザーをデータベースから取得
func GetAllRooms() ([]models.Room, error) {
	var rooms []models.Room
	query := "SELECT id, name, x, y FROM rooms"
	rows, err := database.DB.Query(context.Background(), query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var room models.Room
		if err := rows.Scan(&room.ID, &room.Name, &room.X, &room.Y); err != nil {
			return nil, err
		}
		rooms = append(rooms, room)
	}

	return rooms, nil
}

// 指定されたIDのユーザーをデータベースから取得
func GetRoom(id string) (models.Room, error) {
    var room models.Room
    query := "SELECT id, name, x, y FROM rooms WHERE id = $1"
    err := database.DB.QueryRow(context.Background(), query, id).Scan(&room.ID, &room.Name, &room.X, &room.Y)
    if err != nil {
        return models.Room{}, err
    }

    return room, nil
}
