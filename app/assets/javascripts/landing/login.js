$(function(){
    $(".user_login_input").keypress(function(e) {
        if(e.which == 13) {
            attempt_login();
        }
    });

    $("#user-login-button").on("click", function(){
        attempt_login();
    });
});

function attempt_login() {
    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'user';
    parameters['api_method'] = 'login';
    parameters['email_address'] = $("#user-email-address").val();
    parameters['password'] = $("#user-password").val();

    var error = false;
    var input_id = "";
    var error_message = "";

    if (parameters['email_address'].length == 0)
    {
        input_id = "user-email-address";
        error_message = "email address is required";
        error = true;
    }
    else if (parameters['password'].length == 0)
    {
        input_id = "user-password";
        error_message = "password is required";
        error = true;
    }

    if (error)
    {
        create_notify(input_id, error_message, "right bottom", "error");
        $('#' + input_id).focus();
        return false;
    }

    api_request(parameters, function(response){
        if (response['success']) {

            if(response['account_type'] == 'commuter')
                window.location = 'commuter-dashboard';
            else if(response['account_type'] == 'company')
                window.location = 'company-dashboard';
            else
                window.location = 'trucker-dashboard';

        }
        else{
            create_notify("user-login-button", response['message'], "bottom left", "error", 6000);
        }
    });
}