extends Area2D

var player
var scoreCounterLabel

func _ready() -> void:
	player = $"../../Player"
	scoreCounterLabel = $"../../ScoreCounter"

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		Global.score += 1
	queue_free()
