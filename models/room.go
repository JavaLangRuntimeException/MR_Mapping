package models

type Room struct {
    ID   int    `json:"id"`
    Name string `json:"name"`
    X    int    `json:"x"`
    Y    int    `json:"y"`
}
