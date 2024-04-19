/*
    move_physical_object()

    Moves the object while avoiding all obj_collider objects

    NEEDS TO BE BOUND
    
    Must be bound to the instance which needs to move,
    i.e. use method(id, move_physical_object) in the object's Create event

    @param x                    object's x position
    @param y                    object's y position
    @param move_x               object's x component of movement vector
    @param move_y               object's y component of movement vector
    @param x_speed              maximum x speed at the which object can go
    @param max_falling_speed    maximum y speed at the which object can fall
    @param jump_trigger         the event which triggers the jump (set to False if the object should never jump)
    @param jump_condition       additional condition to allow jumping or not (set to True if it's not needed)
    @param jump_speed           object's jump speed
    @param jumping              boolean whether object is currently jumping or not (i.e. moving up)
    @param falling              boolean whether object is currently falling or not (i.e. moving down)

    @return                     nothing
*/
function move_physical_object(){
    // Check if standing on a obj_collider
    if (place_meeting(x, bbox_bottom + 1, obj_collider) || jumping) {
        make_object_jump(jump_trigger, jump_condition, jump_speed);
    }
    // if not make the object fall
    // NOTE: set max_falling_speed to move_y to stop the object from falling
    else if (move_y < max_falling_speed) {
        move_y += .3;
        falling = true;
    }
    // Get norm of the movement vector to determine how often to check for collisions
    norm_speed = get_vector_norm(move_x, move_y);
    norm_speed = floor(norm_speed) + 1;
    // Move the object
    move_and_collide(move_x, move_y, obj_collider, norm_speed * 2, 0, 0, x_speed, abs(move_y));

    // Now check that the object didn't glitch in a wall
    // if it did: move it back a little
    if place_meeting(bbox_right, y, obj_collider)
        x--;
    else if place_meeting(bbox_left, y, obj_collider)
        x++;
}

/*
    make_object_jump()

    Checks if the jumping conditions are met and returns y component of movement vector accordingly

    NEEDS TO BE BOUND

    @param trigger       the event which triggers the jump (set to False if the object should never jump)
    @param condition     additional condition to allow jumping or not (set to True if it's not needed)
    @param jump_speed    object's jump speed
    @param jumping       boolean whether object is currently jumping (i.e. moving up)

    @return              nothing
*/
function make_object_jump(trigger, condition, jump_speed) {
    // Start the jump
    if (trigger && condition && !jumping) {
        move_y = - jump_speed;
        jumping = true;
    }
    // Continue jumping
    else if (jumping) {
        move_y += .3;
        if (place_meeting(x, bbox_top + move_y, obj_collider)) {
            jumping = false;
        }
    }
    else {
        move_y = 0;
        falling = false;
    }
    // if the object is falling then it's not jumping
    if (move_y > 0) {
        jumping = false;
        falling = true;
    }
}

/*
    knockback_trigger()

    Triggers the knockback event for the specified object

    @param target    instance object to knockback (can be other, self, etc...)
    @param source    instance object triggering the kockback (can be other, self, etc...)
    @param direction real number x-direction in which to move the target

    @return nothing
*/
function knockback_trigger(target, source, direction, iframes_enabled = false) {
    if !target.in_animation && !target.knockedback {
        target.knockedback = true;
        target.in_animation = true;
        target.move_x = sign(direction) * target.knockback_speed;
        if iframes_enabled
            target.invincible = true;
    }
}

/*
    knockback_set_move()

    Set the movement variables for the knockback

    NEEDS TO BE BOUND

    @param knockedback  boolean true when in the knockback event
    @param jumping      boolean whether object is currently jumping (i.e. moving up)
    @param in_animation boolean true when in the animation state (e.g. attacking or knockback)
    @param move_x       object's x component of movement vector

    @return boolean     false when did not run, nothing otherwise
*/
function knockback_set_move() {
    // Only continue if the knock back event has been initiated before
    if !knockedback
        return false;
    // If jumping, stop the jump
    if jumping
        jumping = false;
    // Decrease speed gradually
    move_x = move_x - sign(move_x) * 0.3;
    // if move_x close to 0 then we should stop the knockback
    if -0.15 <= move_x && move_x <= 0.15 {
        move_x = 0;
        knockedback = false;
        in_animation = false;
    }
}

/*
    check_iframes()

    Check if object should still be invincible and set variables accordingly

    NEEDS TO BE BOUND

    @param invincible  boolean true when object needs to be invincible, false otherwise
    @param iframes     int current counter of invincibility frames
    @param ini_iframes int value to reset the iframes counter to

    @return            nothing
*/
function check_iframes() {
    if invincible {
        iframes = check_update_buffer(iframes, init_iframes);
        if iframes == 0
            invincible = false;
    }
}
