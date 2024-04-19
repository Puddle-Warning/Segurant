/// @description Start the room transition

// Start the room transition only when the player is on the ground
if other.move_y = 0 {
    layer_sequence_create("Transitions", other.x, other.y, seq_screen_transition_start);
}

// Trigger the start of the transition in 120 frames and only once
if alarm_trigger == true {
    alarm_set(0, 120);
    alarm_trigger = false;
}
