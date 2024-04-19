/*
    move_on_path_and_react()

    Move on pre-set path and pursue player when seen.

    NEEDS TO BE BOUND

    @param move_x                object's x component of movement vector
    @param path_points           array containing the x coordinates of the path points
    @param trigger_distance      distance at which the the object starts to notice the player
    @param aggro_distance        upper limit horizontal distance at which object will continue pursuing player
    @param enemy_condition       extra condition that needs to be met for the object to pursue player (set to TRUE if not needed)
    @param pursuing              boolean true when object is following the player, false otherwise
    @param on_path               boolean true when object is on its pre-set path
    @param path_x_speed          speed of object when on path or returning to it
    @param x_speed               speed of object when pursuing player
    @param attack_reach_distance distance at which the object can attack the player
    @param override              boolean to set to true to not let the function run

    @return                      nothing or false when it doesn't run completely
*/
function move_on_path_and_react(override) {
    if override {
        move_x = 0;
        return false;
    }

    direction_to_player = get_x_sign_to_direction(x, y, obj_player.x, obj_player.y);
    distance_to_player = point_distance(x, y, obj_player.x, obj_player.y);
    // If looking at player and player in trigger distance or is already then pursue player
    if ((direction_to_player == sign(move_x) && distance_to_player < trigger_distance && enemy_condition) || pursuing) {
        pursue_player();
    }
    // If not pursuing then walk on pre-set path
    else {
        // Initialize path behaviour if not already on the path
        if (!on_path) {
            i = 0;
            target_x = path_points[0];
            on_path = true;
        }
        // As long as not around the target point +- path_x_speed then move towards the target
        if not (x > target_x - path_x_speed && x < target_x + path_x_speed) {
            move_x = get_x_sign_to_direction(x, y, target_x, y) * path_x_speed;
        }
        // Arrived at target point so change to next target point of the path
        else {
            move_x = 0;
            cur_path_buffer = check_update_buffer(cur_path_buffer, init_path_buffer);
            if (cur_path_buffer != 0)
                return false;
            i++;
            if (i == array_length(path_points)) i = 0;
            target_x = path_points[i];
        }
    }
}

/*
    pursue_player()

    Move object towards player when in aggro_distance of player and not at risk of falling

    NEEDS TO BE BOUND

    @param move_x                object's x component of movement vector
    @param direction_to_player   horizontal sign of the direction between object and player
    @param distance_to_player    horizontal distance between object and player
    @param x_speed               horizontal speed at which object will follow player
    @param pursuing              boolean true when object is following the player, false otherwise
    @param aggro_distance        upper limit horizontal distance at which object will continue pursuing player
    @param attack_reach_distance distance at which the object can attack the player

    @return                      nothing
*/
function pursue_player() {
    // Default behaviour: move towards the player
    move_x = direction_to_player * x_speed;
    pursuing = true;
    // Determine where to check for potential fall
    var limit_before_falling = bbox_right + 10;
    if direction_to_player < 0
        limit_before_falling = bbox_left - 10;
    // Actually check that the object is going to fall
    // If it would, stop before it happens
    if (!place_meeting(limit_before_falling, bbox_bottom + 1, obj_collider)) {
        move_x = 0;
    }
    // The player is too far, abort pursuit, return home
    if (distance_to_player > aggro_distance) {
        move_x = 0;
        pursuing = false;
    }
    // Player is close enough to attack, let's go !!
    if (distance_to_player < attack_reach_distance || attacking) {
        move_x = 0;
        attack_target();
    }
}

/*
    attack_target()

    Launches behaviour to attack the target

    NEEDS TO BE BOUND

    @param in_animation         boolean true when in an animation, false otherwise
    @param attacking            boolean true when attacking, false otherwise
    @param attack_sprite        index of the sprite to display when attacking
    @param attack_hitbox_offset number of frames to wait for before creating the the attack's hitbox
    @param cur_attack_buffer    int number of frames to wait for between arming the attack and actually attacking
    @param init_attack_buffer   int initial value of cur_attack_buffer

    @return                     nothing
*/
function attack_target() {
    if !attacking {
        attacking = true;
        // Make sure to start the animation from the beginning
        sprite_index = attack_sprite;
        image_index = 0;
        // Stop the animation from moving
        image_speed = 0;
    }
    else if attacking && !in_animation {
        // Check buffer between arming the attack and acutally attacking
        cur_attack_buffer = check_update_buffer(cur_attack_buffer, init_attack_buffer);
        if cur_attack_buffer != 0
            return false;
        // Attacking proper so set in_animation to true
        in_animation = true;
        // Resume playing the attack animation
        image_speed = 1;
        // Alarm to create the attack's hitbox after attack_hitbox_offset number of frames
        alarm_set(1, attack_hitbox_offset);
    }
}

/*
    animate_object()

    Set the object's proper sprite depending on its movement

    NEEDS TO BE BOUND

    @param running_sprite index of the sprite to display when moving
    @param falling_sprite index of the sprite to display when falling
    @param jumping_sprite index of the sprite to display when jumping
    @param idle_sprite    index of the sprite to display when idle
    @param in_animation   boolean true when in an animation, false otherwise
    @param attacking      boolean true when attacking, false otherwise
    @param move_x         x component of movement vector
    @param move_y         y component of movement vector

    @return               nothing
*/
function animate_object(running_sprite, falling_sprite, jumping_sprite, idle_sprite, hurt_sprite) {
    if !attacking {
        // Knockback animation
        if knockedback {
            sprite_index = hurt_sprite;
        }
        // If in animation then we should abort changing the sprite
        // Knockedback is considered as an animation so we exit only here
        else if in_animation {
            return false;
        }
        // Running animation
        else if (move_x != 0 && move_y == 0) {
            sprite_index = running_sprite;
            image_xscale = sign(move_x);
        }
        // Falling animation
        else if (move_y > 0) {
            sprite_index = falling_sprite;
        }
        // Jumping animation
        else if (move_y < 0) {
            sprite_index = jumping_sprite;
        }
        // Regular idle animation
        else {
            sprite_index = idle_sprite;
        }
    }
}