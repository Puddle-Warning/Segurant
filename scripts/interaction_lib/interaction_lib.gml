/*
    default_callback()

    Funtion that returns nothing meant as a placeholder

    @param nothing

    @return false always
*/
function default_callback() {
    return false;
}

/*
    push_callback()

    Sets movement and state variables for objects that can be pushed

    NEEDS TO BE BOUND

    @param id              instance ID of the object interacting
    @param move_x          object's x component of movement vector
    @param move_y          object's y component of movement vector
    @param interacted_with boolean set to true when object is being interacted with

    @return boolean        false when reset interaction, nothing otherwise
*/
function push_callback(id) {
    // If interacting with something else, or interacting object too low or too high then abort
    if (id.interacting != interactions.nothing && id.interacting != interactions.push) || (id.y > bbox_bottom + 10 || id.y < bbox_bottom - 10)
        return false;
    // Reset interaction when not pressing the button or when falling
    if !keyboard_check(global.kb_inputs.interaction) || move_y > 0 || id.move_y != 0 {
        push_reset(id);
        return false;
    }
    // Set the interacting state
    interacted_with = true;
    // Set the object's interacting state
    id.interacting = interactions.push;
    // Set the interacting object's speed
    id.x_speed = global.reduced_x_speed;
    // Move the object where the interacting object moves
    move_x = id.move_x;
    // Set the interacting object's animation correctly
    if move_x != 0 && id.move_y = 0 {
        id.sprite_index = spr_player_run;
        id.image_xscale = get_x_sign_to_direction(id.x, id.y, x, y);
    }
}

/*
    push_reset()

    Resets the variables that were set when pushing an object

    @param id              instance ID of the object interacting
    @param move_x          object's x component of movement vector
    @param interacted_with boolean set to true when object is being interacted with
*/
function push_reset(id) {
    if interacted_with {
        // The object should stop its movement
        move_x = 0;
        interacted_with = false;
    }
    // Reset the interaction state of the object interacting
    if id.interacting == interactions.push {
        id.interacting = interactions.nothing;
        id.x_speed = global.default_x_speed;
    }
}

/*
    carry_callback()

    Sets movement and state variables for objects that can be carried

    NEEDS TO BE BOUND

    @param id                instance ID of the object interacting
    @param move_x            object's x component of movement vector
    @param interacted_with   boolean set to true when object is being interacted with
    @param carry_path        path on which the object will move when picked up
    @param physical_object   boolean that set if object should obey physics

    @return                  nothing
*/
function carry_callback(id) {
    // Picking up the object
    if keyboard_check_pressed(global.kb_inputs.interaction) && id.interacting == interactions.nothing && !interacted_with {
        // Setting state variables
        interacted_with = true;
        id.interacting = interactions.carry;
        id.in_animation = true;
        // Setting up the pickup path
        path_add_point(carry_path, x, y, 100);
        path_add_point(carry_path, x, id.bbox_top, 100);
        path_add_point(carry_path, id.x, id.bbox_top, 100);
        path_set_closed(carry_path, false);
        // Starting the path
        path_start(carry_path, global.default_x_speed, path_action_stop, true);
    }
    // Throwing the object
    else if keyboard_check_pressed(global.kb_inputs.interaction) && id.interacting == interactions.carry && interacted_with {
        // Re-enable physics for the object
        physical_object = true;
        // Resetting state variables
        interacted_with = false;
        id.interacting = interactions.nothing;
        // Initialize movement vector for the throw
        move_x = sign(id.image_xscale) * global.default_throw_speed;
    }
    // When something is interacting with the object
    if interacted_with {
        // Disable physics for the object because it will move with the object that picked it up
        physical_object = false;
        // When the object arrives at the end of its pick up path
        if path_position == 1 && id.in_animation {
            // Reset the path because it's not needed anymore
            path_end();
            path_clear_points(carry_path);
            // Reset the animation state of the one that picked up the object
            id.in_animation = false;
        }
        // Move the object with the one that picked it up
        x = id.x;
        y = id.bbox_top - 1;
    }
}

/*
    carry_reset()

    Resets the variables that were set when pushing an object

    @param id              instance ID of the object interacting
    @param move_x          object's x component of movement vector
    @param interacted_with boolean set to true when object is being interacted with
    @param physical_object boolean that set if object should obey physics
    @param carry_path      path on which the object will move when picked up
*/
function carry_reset(id) {
    // Reset state variables
    physical_object = true;
    interacted_with = false;
    // Reset movement variable
    move_x = 0;
    // Reset interacting object's state variables
    if id.interacting == interactions.carry {
        id.interacting = interactions.nothing;
        // Reset path if the object is on the path
        if id.in_animation {
            path_end();
            path_clear_points(carry_path);
            // Get the interacting object out of the animation
            id.in_animation = false;
        }
    }
}

/*
    activate_callback()

    Sets animation and state variables for objects that can be activated

    NEEDS TO BE BOUND

    @param id                 instance ID of the object interacting
    @param interacted_with    boolean set to true when object is being interacted with
    @param spr_trans          sprite for activation
    @param spr_trans_reversed sprite for deactivation

    @return                   nothing
*/
function activate_callback(id) {
    // Handle activation
    if keyboard_check_pressed(global.kb_inputs.interaction) && id.interacting == interactions.nothing && !interacted_with {
        // Set state to activated
        interacted_with = true;
        // Start the activation animation
        sprite_index = spr_trans;
        image_index = 0;
    }
    // Handle deactivation
    else if keyboard_check_pressed(global.kb_inputs.interaction) && id.interacting == interactions.nothing && interacted_with {
        // Set state to deactivated
        interacted_with = false;
        // Start the deactivation animation
        sprite_index = spr_trans_reversed;
        image_index = 0;
    }
}