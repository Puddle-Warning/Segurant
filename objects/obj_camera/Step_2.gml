/// @description Have the camera follow the player

#macro view view_camera[0]
camera_set_view_size(view, global.view_width, global.view_height);

if (instance_exists(obj_player))
{
	// Allow moving the camera up and down slightly, to see surroundings
	var _cam_y_offset = 0;
	if keyboard_check(vk_down) or gamepad_button_check(0, gp_padd) {
		_cam_y_offset = 95;		
	}	
	else if keyboard_check(vk_up) or gamepad_button_check(0, gp_padu) {
		_cam_y_offset = - 55;
	}	
	
    var _x = obj_player.x - global.view_width/2;
    var _y = obj_player.y - 35 - global.view_height/2 + _cam_y_offset;

    var cam_x = camera_get_view_x(view);
    var cam_y = camera_get_view_y(view);

    camera_set_view_pos(
        view,
        lerp(cam_x, _x, cam_speed),
        lerp(cam_y, _y, cam_speed)
    );

    cam_speed = .05;
}
