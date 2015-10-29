$(function() {
    $('#reset-password-button').on("click", function() {
        forgot_password();
    });
});

function forgot_password() {
    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'landing';
    parameters['api_method'] = 'forgot_password';
    parameters['reset_email_address'] = $('#reset-email-address').val();
    parameters['HTTP_type'] = 'POST';

    var input_id;
    var error_message;
    var error = false;

    if (parameters['reset_email_address'].length == 0)
    {
        input_id = "reset-email-address";
        error_message = "email address is required";
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
            $('.user_login_input').val("");
            $('#reset-password-button').notify(response['message'], "success");
        }
        else {
            $('#reset-password-button').notify(response['message'], "error");
        }
    });
}