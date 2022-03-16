extends Node2D

onready var _scroll_container = $Background/Margin/VBox/ScrollContainer
onready var _button_container = $Background/Margin/VBox/ScrollContainer/VBox
const _font_path = "res://assets/fonts/Consolas.tres"

var _buttons = []

const _button_height = 400

func _ready():
	NewsController.connect("sig_publish_news", self, "_on_publish_news")
	call_deferred("update_mainpage")

	call_deferred("_DEBUG_add_news")

func _add_button(title, news_index):
	var button = Button.new()
	button.text = title
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.rect_min_size = Vector2(0, _button_height)
	button.mouse_filter = Control.MOUSE_FILTER_PASS
	button.add_font_override("font", load(_font_path))
	button.connect("pressed", self, "_on_news_button_pressed", [news_index])
	_buttons.append(button)
	_button_container.add_child(button)
	button.update()

func _remove_all_buttons():
	for button in _buttons:
		_button_container.remove_child(button)
		button.queue_free()
	_buttons = []

func update_mainpage():
	_remove_all_buttons()
	for news_index in len(NewsController.news):
		var news = NewsController.news[news_index]
		_add_button(news['title'], news_index)
	_scroll_container.scroll_vertical = 0

func _on_news_button_pressed(news_index):
	ViewportManager.change_to_news_app_newspage(news_index)

func _on_BackButton_pressed():
	ViewportManager.change_to_smartphone()

func _on_publish_news():
	call_deferred("update_mainpage")

