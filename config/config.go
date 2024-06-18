package config

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

// LoadConfig は.envファイルから設定をロードする
func LoadConfig() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
}

// GetEnv は環境変数を取得する
func GetEnv(key string) string {
	return os.Getenv(key)
}
