extends Node

var current_work_score = 0
var t_p_counter = 0
var f_p_counter = 0
var t_n_counter = 0
var f_n_counter = 0

func reset_minigame():
	current_work_score = 0
	t_p_counter = 0
	f_p_counter = 0
	t_n_counter = 0
	f_n_counter = 0

func handle_true_positive_penalty(score):
	current_work_score += score
	t_p_counter += 1
func handle_true_negative_penalty():
	t_n_counter += 1
func handle_false_positive_penalty(score):
	current_work_score += score
	f_p_counter += 1
func handle_false_negative_penalty(score):
	current_work_score += score
	f_n_counter += 1
