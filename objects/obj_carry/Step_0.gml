/// @description Step for carryable objects

// Decrease horizontal speed and in mid-air after being thrown
if !interacted_with && move_x != 0 {
    // Decrease horizontal speed
    move_x += - sign(move_x) * 0.3;
    // Once it's on the ground stop the horzontal movement
    if move_y == 0
        move_x = 0;
}

// Inherit the parent event
event_inherited();
