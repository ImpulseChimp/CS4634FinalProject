$("#add-truck").on("click", function() {
    $("#add-truck-popup").bPopup();
});

$("#submit-new-truck").on("click", function() {

    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'company';
    parameters['api_method'] = 'create-truck';
    parameters['driver-email'] = $("#driver-email").val();
    parameters['license-plate'] = $("#license-plate").val();

    if(parameters['driver-email'].length == 0) {
        alert("Email cannot be empty");
        return false;
    }
    else if(parameters['license-plate'].length == 0) {
        alert("License plate cannot be empty");
        return false;
    }

    api_request(parameters, function(response){
        if(response['success']) {
            $(".new-truck-input").val("");
            $("#add-truck-popup").bPopup().close();
        }
        else {
            alert("Error: Problem occurred when creating a new truck");
        }
    });
});