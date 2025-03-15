extends Line2D

var queue = []
var max_queue_size = 10
#var subViewport: SubViewport
#var parent: Node2D
var offset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offset = Vector2(5,5) #Vector2(subViewport.Size.X / 2, subViewport.Size.Y / 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var position = offset
	add_to_queue(position)

# Add an item to the queue if it has not reached its maximum capacity
func add_to_queue(item):
	if len(queue) < max_queue_size:
		queue.push_back(item)

# Removes the front item from the queue and returns whether or not the queue was empty
func finish_queue_front():
	return bool(queue.pop_front())
