/*
    BEGIN SAVES VARIABLES
*/

global.system_data = {
    custom_controls : 0,
    general_settings : 0
};

global.save_data = {
    date : 0,
    room_name : 0,
    player_data : 0,
    layers_data : []
};

/*
    Structure of global.last_checkpoint should be:

    global.last_checkpoint = {
        room_name1 : {
            date : DateTime Object,
            player_data : struct (see save_player_data() for its structure),
            layers_data : array (see below for its structure)
        },
        room_name2 : {
            same structure for every rooms...
        },
        etc for every rooms...
    }

    Structure of layers_data should be:
    layers_data = [
        [
            "string layer name 1",
            [
                ["string object name 1", struct object 1 variables],
                ["string object name 2", struct object 1 variables],
                etc for every objects on the layer...
            ]
        ],
        [
            "string layer name 2",
            [
                array of objects on the layer, same structure for every layers...
            ]
        ],
        etc for every layers defined in global.layers_ids...
    ]
*/
global.last_checkpoint = {};

// DO NOT MODIFY THE ORDER IN THE ARRAY
global.layers_ids = {
    room_name : 0,
    ids : [
        ["enemies", undefined],
        ["interactables", undefined]
    ]
};

/*
    END SAVES VARIABLES
*/

/*
    get_layers_ids()

    Populate global.layers_ids for later saving and loading of instances

    @param nothing

    @return nothing
*/
function get_layers_ids() {
    var layer_id;
    global.layers_ids.room_name = room_get_name(room);
    for (var i = 0; i < array_length(global.layers_ids.ids); i++) {
        layer_id = layer_get_id(global.layers_ids.ids[i][0]);
        if layer_id != -1
            global.layers_ids.ids[i][1] = layer_id;
    }
}

/*
    reset_save_variables()

    Reset the variables saved to the save files to free memory

    @param nothing

    @return nothing
*/
function reset_save_variables() {
    global.save_data = {
        date : 0,
        room_name : 0,
        player_data : 0,
        layers_data : []
    };
}

/*
    get_layers_data()

    Retrieves the layers' instances info for saving

    @param nothing

    @return array all the instances on the layers in global.layers_ids, in the room in which the function was called
*/
function get_layers_data() {
    var elements, save_all_elements, element_name, save_element, instance;
    var layers_data = [];
    // Loop over the layers we are interested in
    for (var i = 0; i < array_length(global.layers_ids.ids); i++) {
        save_all_elements = [];
        // Get all the instances in the layer
        elements = layer_get_all_elements(global.layers_ids.ids[i][1]);
        // Loop over all the instances to save
        for (var j = 0; j < array_length(elements); j++) {
            instance = layer_instance_get_instance(elements[j]);
            // Get the instance's object name
            element_name = object_get_name(instance.object_index);
            // If it has custom saving, use that otherwise just save the position
            if instance.custom_save {
                save_element = instance.save_this_object();
            }
            else {
                save_element = { x : instance.x, y : instance.y};
            }
            // Store the element's info
            array_push(save_all_elements, [element_name, save_element]);
        }
        // Store the layer's info
        array_push(layers_data, [global.layers_ids.ids[i][0], save_all_elements]);
    }
    return layers_data;
}

/*
    construct_save_data()

    Builds the save_data struct to save the current state of the game

    @param nothing

    @return nothing
*/
function construct_save_data() {
    // Get the layers' info
    global.save_data.layers_data = get_layers_data();
    // Save the room's name
    global.save_data.room_name = room_get_name(room);
    // Activate the player object to be able to get its data
    if !instance_exists(obj_player)
        instance_activate_object(obj_player);
    // Store in the global save_data
    global.save_data.player_data = obj_player.save_player_data();
    // Once the data has been gathered deactivate the player object
    if instance_exists(obj_player)
        instance_deactivate_object(obj_player);
    //Saving the date at which the save is made
    global.save_data.date = date_current_datetime();
}

/*
    load_save_data()

    Load the save data into the current room

    @param nothing

    @return boolean false if the room has not been saved before, true otherwise
*/
function load_save_data() {
    // If save_data doesn't exist then exit the function
    if global.save_data.date == 0
        return false;
    // We can proceed so clear the layers first
    clear_layers();
    var object_id;
    // Check that the layers ids were gathered in this room
    if global.layers_ids.room_name != room_get_name(room)
        get_layers_ids();
    // Loop over the layers
    for (var layer_index = 0; layer_index < array_length(global.save_data.layers_data); layer_index++) {
        // Loop over the elements on the layer
        for (var element_index = 0; element_index < array_length(global.save_data.layers_data[layer_index][1]); element_index++) {
            // Get the object index to place from its name
            object_id = asset_get_index(global.save_data.layers_data[layer_index][1][element_index][0]);
            // Create the instance on the layer
            instance_create_layer(
                0,
                0,
                global.layers_ids.ids[layer_index][1],
                object_id,
                global.save_data.layers_data[layer_index][1][element_index][1]);
        }
    }
    // Destroy the player if it exists
    instance_destroy(obj_player, false);
    // Put the player back where it was
    instance_create_layer(
        global.save_data.player_data.x,
        global.save_data.player_data.y,
        "player",
        obj_player,
        global.save_data.player_data);
    return true;
}

/*
    checkpoint_to_save()

    Saves room's last obtained checkpoint to the save_data struct

    @param nothing

    @return nothing
*/
function checkpoint_to_save() {
    var room_name = room_get_name(room);
    var checkpoint_struct = struct_get(global.last_checkpoint, room_name);
    // If no checkpoint taken in this room then exit the function
    if is_undefined(checkpoint_struct)
        return false;
    // Get the layers' info
    global.save_data.layers_data = checkpoint_struct.layers_data;
    // Save the room's name
    global.save_data.room_name = room_name;
    // Store in the global save_data
    global.save_data.player_data = checkpoint_struct.player_data;
    //Saving the date at which the save is made
    global.save_data.date = checkpoint_struct.date;
}

/*
    construct_last_checkpoint()

    Builds the last_checkpoint struct to save the state of the game when got the checkpoint of the room

    @param nothing

    @return nothing
*/
function construct_last_checkpoint(x_pos = undefined, y_pos = undefined) {
    var room_name = room_get_name(room);
    // Now save the player data
    var player_data = obj_player.save_player_data();
    if !is_undefined(x_pos) && !is_undefined(y_pos) {
        player_data.x = x_pos;
        player_data.y = y_pos;
    }
    // Get the layers' info
    var layers_data = get_layers_data();
    var struct_buffer = {
        date : date_current_datetime(),
        player_data : player_data,
        layers_data : layers_data
    };
    // Save all that in global.last_checkpoint
    struct_set(global.last_checkpoint, room_name, struct_buffer);
    // Also save this as global.save_data in case the game is not exited properly
    struct_buffer.room_name = room_name;
    global.save_data = struct_buffer;
}

/*
    load_last_checkpoint()

    Load the last checkpoint data into the current room

    @param nothing

    @return boolean false if the room has not been saved before, true otherwise
*/
function load_last_checkpoint(load_player = true) {
    var room_name = room_get_name(room);
    var checkpoint_struct = struct_get(global.last_checkpoint, room_name);
    // If no checkpoint taken in this room then exit the function
    if is_undefined(checkpoint_struct)
        return false;
    // We can proceed so clear the layers first
    clear_layers();
    // Check that the layers ids we gathered in this room
    if global.layers_ids.room_name != room_name
        get_layers_ids();
    var object_id;
    // Loop over the layers
    for (var layer_index = 0; layer_index < array_length(checkpoint_struct.layers_data); layer_index++) {
        // Loop over the elements on the layer
        for (var element_index = 0; element_index < array_length(checkpoint_struct.layers_data[layer_index][1]); element_index++) {
            // Get the object index to place from its name
            object_id = asset_get_index(checkpoint_struct.layers_data[layer_index][1][element_index][0]);
            // Create the instance on the layer
            instance_create_layer(
                checkpoint_struct.layers_data[layer_index][1][element_index][1].x,
                checkpoint_struct.layers_data[layer_index][1][element_index][1].y,
                global.layers_ids.ids[layer_index][1],
                object_id,
                checkpoint_struct.layers_data[layer_index][1][element_index][1]);
        }
    }
    // Load the player if needed
    if load_player {
        // Destroy the player if it exists
        instance_destroy(obj_player, false);
        // Create it anew
        instance_create_layer(
            checkpoint_struct.player_data.x,
            checkpoint_struct.player_data.y,
            "player",
            obj_player);
            // Not needed for now unless there is some persistent stuff that should be kept after death
            //checkpoint_struct.player_data);
    }
    return true;
}

/*
    clear_layers()

    Destroy all the instances on the layers in global.layers_ids

    @param nothing

    @return nothing
*/
function clear_layers() {
    var room_name = room_get_name(room);
    // Check that the layers ids we gathered in this room
    if global.layers_ids.room_name != room_name
        get_layers_ids();
    for (var i = 0; i < array_length(global.layers_ids.ids); i++) {
        layer_destroy_instances(global.layers_ids.ids[i][1]);
    }
}

/*
    save_to_file()

    Writes the save structs to the save file

    @param nothing

    @return nothing

    @remark writes a json list, the first element is save_data and the second is last_checkpoint
*/
function save_to_file() {
    // Transform the save data into JSON format
    var save_string = json_stringify([global.save_data, global.last_checkpoint]);
    // Open file, write in it, and close it
    var file = file_text_open_write("save.sv");
    file_text_write_string(file, save_string);
    file_text_close(file);
}

/*
    load_from_file()

    Loads the save structs from the save file

    @param nothing

    @return boolean true if loading succeeded, false otherwise
*/
function load_from_file() {
    // Open the file and exit if it doesn't exist
    var file = file_text_open_read("save.sv");
    if file == -1
        return false;
    // Get the save data text from the file
    var save_string = file_text_read_string(file);
    file_text_close(file);
    // Transform the data JSON into the different structures and store them
    var data = json_parse(save_string);
    global.save_data = data[0];
    global.last_checkpoint = data[1];
    return true;
}
