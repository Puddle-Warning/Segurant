/// @description Default variables for interactable objects

// Set to true in the child object's create if it can be interacted with only once
interact_only_once = false;

// Boolean true when currently interacted with or has been interacted with once
interacted_with = false;

// Radius in pixels within which interaction can happen
interaction_radius = 20;

// Variable sotring the id of the instance that will collision with the object
collision_id = noone;
last_collision_id = noone;

// Override this boolean if the object needs to be subject to physics
// Don't forget to set the proper variables in its create event
physical_object = false;
// Method to move the object if it's subject to physics
move_interactable_object = method(id, move_physical_object);

// Function called when the interaction happens
// overwrite this varaible with the proper function in the child object's create
interaction_callback = method(id, default_callback);

// Callback that resets the states in case something went wrong
reset_callback = method(id, default_callback);

// This object does NOT have a custom saving method
custom_save = false;
