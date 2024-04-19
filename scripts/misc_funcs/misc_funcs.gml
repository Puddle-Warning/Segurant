// Global variables
global.debug = true;

/*
    get_vector_norm()

    Given the x and y components of a vector, returns its norm

    @param x_comp x component of the vector
    @param y_comp y component of the vector

    @return real  norm of the vector with components x_comp and y_comp
*/
function get_vector_norm(x_comp, y_comp){
    return sqrt(sqr(x_comp) + sqr(y_comp));
}

/*
    get_x_sign_to_direction()

    Get the horizontal sign of the direction

    @param x_origin      x coordinate of the point from which the direction originates
    @param y_origin      y coordinate of the point from which the direction originates
    @param x_destination x coordinate of the point to which the direction goes
    @param y_destination y coordinate of the point to which the direction goes

    @return  +1/-1       sign of the horizontal direction. +1 for positive x, -1 for negative x
*/
function get_x_sign_to_direction(x_origin, y_origin, x_destination, y_destination) {
    return sign(dcos(point_direction(x_origin, y_origin, x_destination, y_destination)));
}

/*
    get_y_sign_to_direction()

    Get the vertical sign of the direction

    @param x_origin      x coordinate of the point from which the direction originates
    @param y_origin      y coordinate of the point from which the direction originates
    @param x_destination x coordinate of the point to which the direction goes
    @param y_destination y coordinate of the point to which the direction goes

    @return  +1/-1       sign of the vertical direction. +1 for positive y, -1 for negative y
*/
function get_y_sign_to_direction(x_origin, y_origin, x_destination, y_destination) {
    return -sign(dsin(point_direction(x_origin, y_origin, x_destination, y_destination)));
}

/*
    allow_keyboard_input()

    Check if input condition is met before checking and returning keyboard check

	@param input_condition boolean variable that needs to be set up in object to check ability of registering input
    @param input_check     input that keyboard_check() needs to check
	
    @return boolean        result of the input if input_condition is met, false otherwise
*/
function allow_keyboard_input(input_condition, input_check) {
    if (input_condition) {
        return keyboard_check(input_check);
    }
    return false;
}

/*
    allow_gamepad_input()

    Check if input condition is met before checking and returning gamepad check

	@param input_condition boolean variable that needs to be set up in object to check ability of registering input
    @param input_check     input that gamepad_button_check() needs to check
	
    @return boolean        result of the input if input_condition is met, false otherwise
*/
function allow_gamepad_input(input_condition, input_check) {
    if (input_condition) {
        return gamepad_button_check(0, input_check);
    }
    return false;
}

/*
    allow_keyboard_pressed_input()

    Check if input condition is met before checking and returning keyboard pressed check

	@param input_condition boolean variable that needs to be set up in object to check ability of registering input
    @param input_check     input that keyboard_check_pressed() needs to check
	
    @return boolean        result of the input if input_condition is met, false otherwise
*/
function allow_keyboard_pressed_input(input_condition, input_check) {
    if (input_condition) {
        return keyboard_check_pressed(input_check);
    }
    return false;
}

/*
    allow_gamepad_pressed_input()

    Check if input condition is met before checking and returning gamepad pressed check

	@param input_condition boolean variable that needs to be set up in object to check ability of registering input
    @param input_check     input that gamepad_button_check_pressed() needs to check
	
    @return boolean        result of the input if input_condition is met, false otherwise
*/
function allow_gamepad_pressed_input(input_condition, input_check) {
    if (input_condition) {
        return gamepad_button_check_pressed(0, input_check);
    }
    return false;
}

/*
    allow_mouse_pressed_input()

    Check if input condition is met before checking and returning mouse check

	@param input_condition boolean variable that needs to be set up in object to check ability of registering input
    @param input_check     input that mouse_check_button_pressed() needs to check
	
    @return boolean        result of the input if input_condition is met, false otherwise
*/
function allow_mouse_pressed_input(input_condition, input_check) {
    if (input_condition) {
        return mouse_check_button_pressed(input_check);
    }
    return false;
}		

/*
    check_update_buffer()

    NEEDS TO BE BOUND

    @param buffer_int      buffer integer that needs to be checked and updated
    @param init_buffer_int initial value of the buffer integer to re-init to

    @return int            updated buffer int
*/
function check_update_buffer(buffer_int, init_buffer_int) {
    if (buffer_int > 0) {
        buffer_int--;
    }
    else {
        buffer_int = init_buffer_int;
    }
    return buffer_int;
}