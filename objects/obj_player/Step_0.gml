/// @description General behaviour of the player

/*
	BEGIN PLAYER SPECIAL ACTIONS
*/

// ATTACK
// Check for attack input
if ((allow_mouse_pressed_input(input_condition, mb_left) || allow_gamepad_pressed_input(input_condition, gp_face3)) && sprite_index != spr_player_attack) {
	// Start animation from begining
	image_index = 0;
	sprite_index = spr_player_attack;
	audio_play_sound(snd_attack, 1, false);
	// Alarm to create the attack's hitbox
	alarm_set(0, 6);
	// Attacking is considered as an animation to prevent movement when attacking
	// Reset to false in the End Animation event
	in_animation = true;
}

// BLOCK
// Allow blocking if enough stamina
if ((allow_keyboard_input(!in_animation, global.kb_inputs.block) || allow_gamepad_input(!in_animation, gp_shoulderl)) && cur_stamina > 0) {
	// Start the blocking animation the first time the keys are pressed
	if !blocking {
		image_index = 0;
		sprite_index = spr_player_block;
		// Set the blocking state
		blocking = true;
	}
}
// Reset blocking state only if was blocking before (this prevents rewriting to memory every frame)
else if blocking {
	blocking = false;
}

/*
	END PLAYER SPECIAL ACTIONS
*/

// Setting some state variables here in case special actions have an impact
// Setting the input_condition every frame to ensure that the player can use inputs (or not) this frame
input_condition = !in_animation && !blocking;

/*
	BEGIN PLAYER MOVEMENTS
*/

// Setting the movement variables depending on whether the player can move or not
// Check keyboard inputs
if !knockedback {
	move_x = allow_keyboard_input(input_condition, global.kb_inputs.right) - allow_keyboard_input(input_condition, global.kb_inputs.left) +
	// And also check gamepad inputs
			allow_gamepad_input(input_condition, gp_padr) - allow_gamepad_input(input_condition, gp_padl);
	move_x *= x_speed;
}

// Setting jump variables
jump_trigger = allow_keyboard_pressed_input(input_condition, global.kb_inputs.jump) || allow_gamepad_pressed_input(input_condition, gp_face1);
jump_condition = !in_animation;

// Setting the knockback variables if player is knocked back
knockback_player();

// Check for and launch room-transition player behaviour
if (place_meeting(x, y, obj_screen_transition_leave_right)) {
	move_x = x_speed;
	in_animation = true;
	jump_trigger = false;
}

// Finally move the player use the variables set above
move_player();

/*
	END PLAYER MOVEMENTS
*/

/*
	BEGIN MOVEMENT-BASED ANIMATION HANDLING
*/

if sprite_index != spr_player_attack && !blocking {
	if knockedback {
		sprite_index = spr_player_hurt;
	}
	// Running animation
	else if (move_x != 0 && move_y = 0 && interacting != interactions.push) {
		sprite_index = spr_player_run;
		image_xscale = sign(move_x);
	}
	// Falling animation
	else if (move_y > 0) {
		sprite_index = spr_player_fall;
	}
	// Jumping animation
	else if (move_y < 0) {
		sprite_index = spr_player_jump;
	}
	// Regular idle animation
	else if sprite_index != spr_player_idle_2 {
		sprite_index = spr_player_idle_1;
	}
}

/*
	END MOVEMENT-BASED ANIMATION HANDLING
*/

/*
	BEGIN LIFE HANDLING
*/

// Check if the player is still invincible
iframes_player();

// Regen stamina only when not blocking and not attacking and regen is actually needed
if !blocking && cur_stamina < max_stamina && !in_animation {
	// Update the cooldown every frame
	regen_stamina = check_update_buffer(regen_stamina, init_regen_stamina);
	if regen_stamina == 0
		cur_stamina++;
}

/*
	END LIFE HANDLING
*/