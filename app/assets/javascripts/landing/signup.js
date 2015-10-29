$(function(){
    $(".user-sign-up-input").keypress(function(e) {
        if(e.which == 13) {
            attempt_sign_up();
        }
    });

    $('#user-sign-up-button').click(function(){
        attempt_sign_up();
    });
});


function attempt_sign_up(){

    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'user';
    parameters['api_method'] = 'register';
    parameters['user_first_name'] = $('#user_first_name').val();
    parameters['user_last_name'] = $('#user_last_name').val();
    parameters['user_email_address'] = $('#user_email_address').val();
    parameters['user_password'] = $('#user_password').val();
    parameters['user_confirmed_password'] = $('#user_confirmed_password').val();
    parameters['HTTP_type'] = 'POST';

    var error = false;
    var input_id = "";
    var error_message = "";


    if (parameters['user_first_name'].length == 0)
    {
        input_id = "user_first_name";
        error_message = "First name is required";
        error = true;
    }
    else if (parameters['user_last_name'].length == 0)
    {
        input_id = "user_last_name";
        error_message = "Last name is required";
        error = true;
    }
    else if (parameters['user_email_address'].length == 0)
    {
        input_id = "user_email_address";
        error_message = "email address is required";
        error = true;
    }
    else if (parameters['user_password'].length == 0 )
    {
        input_id = "user_password";
        error_message = "A password is required";
        error = true;
    }
    else if (parameters['user_password'].length > 0 && parameters['user_password'] != parameters['user_confirmed_password'])
    {
        input_id = "user_confirmed_password";
        error_message = "Passwords do not match";
        error = true;
    }

    if (error)
    {
        create_notify(input_id, error_message, "right bottom", "error", 4000);
        $('#' + input_id).focus();
        return false;
    }

    api_request(parameters, function(response){
        if(response['success']) {
            $('.user-sign-up-input').val("");
            $('#successful-registration-view').bPopup();
        }
        else {
            $('#user-sign-up-button').notify(response['message'], "error");
        }
    });
}

