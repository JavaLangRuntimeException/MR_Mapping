package database

import (
	"context"
	"log"
	"mrmapping.com/mrmapping/config"

	"github.com/jackc/pgx/v4"
)

// DB はデータベースへの接続を保持します。
var DB *pgx.Conn

// InitDB はデータベースを初期化し、接続を確立します。
func InitDB() {
	var err error

	// DATABASE_URL環境変数からdatabaseのURIを取得
	dsn := config.GetEnv("DATABASE_URL")

	// pgxライブラリを使用して、DSNを使用してデータベースに接続
	DB, err = pgx.Connect(context.Background(), dsn)

	if err != nil {
		log.Fatalf("Unable to parse DSN: %v\n", err)
	}

	// ユーザーのテーブルが存在しない場合は作成
	createTableSQL := `
		CREATE TABLE IF NOT EXISTS rooms (
			id SERIAL PRIMARY KEY,
			name TEXT,
			x INTEGER,
			y INTEGER
		);`
	_, err = DB.Exec(context.Background(), createTableSQL)
	if err != nil {
		log.Fatalf("Failed to create table: %v\n", err)
	}
}
