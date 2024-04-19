// Gather layers ids for saving functions
get_layers_ids();

room_start = {
    x : 130,
    y : 351
};

if global.died {
    global.died = false;
    // Load last checkpoint and the player
    if !load_last_checkpoint() {
        // This is temporary until the room transition system is finalised
        obj_player.x = room_start.x;
        obj_player.y = room_start.y;
    }
    exit;
}

if global.changing_room {
    global.changing_room = false;
    // Load last checkpoint but not the player (it will be placed correctly another way)
    load_last_checkpoint(false);
    exit;
}

load_save_data();