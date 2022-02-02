extends Node2D

var _transactions = []

onready var balance_label = $Background/Margin/VBox/HBox/BalanceLabel
onready var transaction_history_label = $Background/Margin/VBox/TransactionHistoryLabel

func persistent_state():
	return {
		'transactions': _transactions
	}
	
func restore_state(state):
	_transactions = state['transactions']
	_display_transactions()
	
func _ready():
	EventBus.connect("sig_add_money", self, "_on_add_money")
	GameStateController.connect("sig_money_changed", self, "_on_money_changed")
	_display_transactions()
	_display_balance()
	
	# call_deferred("_DEBUG_add_transactions")

func _on_add_money(amount, description):
	_transactions.append([amount, description])
	_display_transactions()
	var notification_text = "Bank transfer: " + str(amount)
	EventBus.emit_signal("sig_notification", 'bank', notification_text)
	
	
func _on_money_changed(amount):
	_display_balance()
	
func _display_balance():
	balance_label.text = str(GameStateController.money) + " ¥"
	
func _display_transactions():
	transaction_history_label.clear()
	for transaction in _transactions:
		var color = "green"
		if transaction[0] < 0:
			color = "red"
		transaction_history_label.append_bbcode(
			"\n\n[color=" + color + "]" + transaction[1] + "[right]" + str(transaction[0]) + " ¥[/right][/color]"
		)
	transaction_history_label.scroll_to_line(transaction_history_label.get_line_count() - 1)

func _DEBUG_add_transactions():
	EventBus.emit_signal("sig_add_money", 1000, "Loan")
	EventBus.emit_signal("sig_add_money", -500, "Rent")
	EventBus.emit_signal("sig_add_money", -100, "Groceries")

func _on_BackButton_pressed():
	ViewportManager.change_to_smartphone()
