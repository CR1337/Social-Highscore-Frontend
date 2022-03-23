extends Node

signal sig_debug_error(error)

signal sig_trigger(trigger_id, kwargs)
signal sig_dialog_trigger_completed()

signal sig_got_phone_message(contact, message)
signal sig_opened_message(contact)

signal sig_add_money(amount, recipient)

signal sig_notification(type, text)

signal sig_payment_successfull(handle)
signal sig_payment_failed(handle)

signal sig_fridge_content_changed()

signal sig_ate_in_mall(item_key)

signal sig_what_next()
