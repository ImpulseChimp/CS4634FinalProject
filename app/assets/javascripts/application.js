// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs

function create_notify(input_id, message, location, type, delay)
{
    $('#' + input_id).notify(message, {
        elementPosition: location,
        className: type,
        autoHideDelay: delay
    });
}

//All global variables for the apis
var apiCallInProgress = false;


function api_delete_test() {
    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'user';
    parameters['api_method'] = 'delete';
    parameters['user_id'] = '0bd724ef-ac6c-4aed-9e86-f362abbcd9a7';
    parameters['user_first_name'] = 'Gerry';
//    parameters['user_last_name'] = 'Testing';
    parameters['HTTP_type'] = 'DELETE';

    api_request(parameters, function(response){
        if(response['success'] == true) {
            console.log(response);
        }
        else {
            console.log(response);
        }
    });
}


function api_update_test() {
    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'user';
    parameters['api_method'] = 'update';
    parameters['user_id'] = '0bd724ef-ac6c-4aed-9e86-f362abbcd9a7';
    parameters['user_first_name'] = 'Gerry';
    parameters['user_last_name'] = 'Willard';
    parameters['HTTP_type'] = 'PATCH';

    api_request(parameters, function(response){
        console.log(response);
    });
}

function api_create_test(){
    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'user';
    parameters['api_method'] = 'create';
    parameters['user_first_name'] = 'Christopher';
    parameters['user_last_name'] = 'Wood';
    parameters['user_email_address'] = 'cmw2379@vt.edu';
    parameters['user_password'] = 'testpass';
    parameters['user_confirmed_password'] = 'testpass';
    parameters['HTTP_type'] = 'POST';

    api_request(parameters, function(response){
        if(response['success'] == true) {
            console.log(response);
        }
        else {
            console.log(response);
        }
    });
}

function logout() {
    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'user';
    parameters['api_method'] = 'logout';

    api_request(parameters, function(response){
        if(response['success']) {
            window.location = 'login';
        }
    });
}

function logout_admin() {
    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'admin';
    parameters['api_method'] = 'logout';

    api_request(parameters, function(response){
        if(response['success']) {
            window.location = 'admin';
        }
    });
}

/**
 * Makes a call to the site API
 * @param parameters All parameters being sent to the request
 * @param callback The callback function
 */
function api_request(pars, callback) {

    //Every request starts valid till proven wrong
    var api_response = null;
    var validRequest = true;

    //Validate request before proceeding
    if (!typeof(pars['version']==='string')) { validRequest = false; }
    if (!typeof(pars['api_name']==='string')) { validRequest = false; }
    if (!typeof(pars['api_method']==='string')) { validRequest = false; }
    if (!typeof(pars['HTTP_type']==='string')) { validRequest = false; }

    if (validRequest) {

        //Build request url
        var request_url = 'http://' + window.location.host + '/api/' + pars['version'] + '/' + pars['api_name'] + '/' +
            pars['api_method'];

        var request = $.ajax({
                url: request_url,
                data: pars,
                dataType: 'json',
                processData: true
            });

        request.done(function(data){
            api_response = data;
            if (typeof(callback)==='function')
            {
                callback(data);
            }
        });
        request.fail(function(data){
            api_response = data;
            if (typeof(callback)==='function')
            {
                callback(data);
            }
        });

        return api_response;
    }
    else {
        return false;
    }

}