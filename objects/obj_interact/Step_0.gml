/// @description Default step for interactable objects

// Check if the player is in radius to interact
collision_id = collision_circle(x, y, interaction_radius, obj_player, false, true);
// Check if the player is nearby and the object can still be interacted with
if collision_id != noone && !(interact_only_once && interacted_with) {
    // Call the interaction function to handle what happens to the object
    interaction_callback(collision_id);
}

// Resolve the object's physics if it should obey physics
if physical_object {
    move_interactable_object();
}

// If the player is not nearby anymore but the object is still in the interaction state
// then something is wrong so call the reset callback for the interaction
if collision_id == noone && interacted_with {
    reset_callback(last_collision_id);
}

// Remember the last id of the player so that if something goes wrong we can reset things
if collision_id != noone && collision_id != last_collision_id {
    last_collision_id = collision_id;
}