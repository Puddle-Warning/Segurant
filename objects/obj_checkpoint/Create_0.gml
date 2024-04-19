/// @description Variables for the checkpoints

// Checkpoints can only save the game once
if !variable_instance_exists(id, "already_used")
    already_used = false;

// This object has a custom saving method
custom_save = true;

function save_this_object() {
    var data = {
        x : x,
        y : y,
        already_used : already_used
    };
    return data;
}
