extends Area2D

var player
var scoreCounterLabel
const soundEffectTimer = 0.5

func _ready() -> void:
	player = $"../../Player"
	scoreCounterLabel = $"../../ScoreCounter"
	

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		if not $CoinCollectedSound.playing:
			$CoinCollectedSound.play()
			$".".visible = false
		else:
			$CoinCollectedSound.stop()
		Global.score += 1
	


func _on_coin_collected_sound_finished() -> void:
	queue_free()
