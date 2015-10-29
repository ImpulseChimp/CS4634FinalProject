$(function(){
    $(".admin-login-input").keypress(function(e) {
        if(e.which == 13) {
            attempt_admin_login();
        }
    });

    $("#admin-login-button").on("click", function(){
        attempt_admin_login();
    });
});

function attempt_admin_login() {
    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'admin';
    parameters['api_method'] = 'login';
    parameters['email_address'] = $("#admin-email-address").val();
    parameters['password'] = $("#admin-password").val();

    var error = false;
    var input_id = "";
    var error_message = "";

    if (parameters['email_address'].length == 0)
    {
        input_id = "admin-email-address";
        error_message = "email address is required";
        error = true;
    }
    else if (parameters['password'].length == 0)
    {
        input_id = "admin-password";
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
        if (response['success'] && response['message'] == 'User Authenticated') {
            window.location = 'admin_dashboard';
        }
        else{
            create_notify("admin-login-button", response['message'], "bottom left", "error", 6000);
        }
    });
}