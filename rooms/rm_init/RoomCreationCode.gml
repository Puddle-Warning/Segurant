/// @description Load save data and move to the appropriate room

// Load the save data and move to the first room if no save data exists
if !load_from_file() || global.save_data.room_name == 0 {
    room_goto_next();
    exit;
}

// Move to the room referenced in the save data
room_goto(asset_get_index(global.save_data.room_name));