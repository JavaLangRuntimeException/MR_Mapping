package models

// User はユーザーを表すデータ構造体
type Room struct {
	ID   int    `json:"id" db:"id"`     // ユーザーのID
	Name string `json:"name" db:"name"` // ユーザーの名前
	X    string `json:"x" db:"x"`
	Y    string `json:"y" db:"y"`
}
