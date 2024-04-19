/// @description Variables for pushable objects
event_inherited();

// Radius in pixels within which interaction can happen
interaction_radius = 40;

// Pushable objects obey physics
physical_object = true;

// Function called when the interaction happens
interaction_callback = method(id, push_callback);

// Function called when something is wrong
reset_callback = method(id, push_reset);

// BEGIN PHYSICS VARIABLES

move_x = 0;
move_y = 0;
x_speed = global.reduced_x_speed;
max_falling_speed = global.default_falling_speed;
jump_trigger = false;
jump_condition = false;
jump_speed = 0;
jumping = false;
falling = false;

// END PHYSICS VARIABLES
