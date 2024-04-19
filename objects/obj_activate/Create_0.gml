/// @description Variables for activatable objects
event_inherited();

// If the object should only be activated once, don't forget to set the following variable to true
// interact_only_once = true;

// Function called when the interaction happens
interaction_callback = method(id, activate_callback);

// Define the different sprites
spr_begin = spr_lever_begin;
spr_trans = spr_lever_trans;
spr_trans_reversed = spr_lever_trans_rev;
spr_end = spr_lever_end;

// Be sure to initialize the sprite
sprite_index = spr_begin;
