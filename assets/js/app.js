// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import $ from "jquery"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

$('#registration_member_option_false').click(function () {
    var $membership_number = $("#registration_membership_number");
    var $membership_date = $("#registration_membership_expiration_date");
    $membership_number.prop( "disabled", true );
    $membership_date.prop( "disabled", true );
    $membership_number.val('');
    $membership_date.val('');
});

$('#registration_member_option_true').click(function () {
    var $membership_number = $("#registration_membership_number");
    var $membership_date = $("#registration_membership_expiration_date");
    $membership_number.prop( "disabled", false );
    $membership_date.prop( "disabled", false );
});
