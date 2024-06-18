
FROM golang:1.22.2-alpine

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go mod tidy

# ビルドステップは削除し、直接 go run を使用
CMD ["go", "run", "main.go"]