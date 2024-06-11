FROM golang:1.22.2-alpine

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go mod tidy

# ビルドステップ
RUN go build -o starter -ldflags="-s -w" main.go
RUN chmod +x starter

# 実行コマンド
CMD ["./starter"]
