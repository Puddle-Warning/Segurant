/// @description Variables for carryable objects
event_inherited();

// Radius in pixels within which interaction can happen
interaction_radius = 20;

// Carryable objects obey physics
physical_object = true;

// Function called when the interaction happens
interaction_callback = method(id, carry_callback);

// Function called when something is wrong
reset_callback = method(id, carry_reset);

// BEGIN PHYSICS VARIABLES

move_x = 0;
move_y = 0;
x_speed = -1;
max_falling_speed = global.default_falling_speed;
jump_trigger = false;
jump_condition = false;
jump_speed = 0;
jumping = false;
falling = false;

// END PHYSICS VARIABLES

// Initialize the path that object will follow in the pick-up animation
carry_path = path_add();
