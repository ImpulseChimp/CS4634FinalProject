function viewTruckPopup(truck_id) {
    $(".view_truck_popup_input").val("");

    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'truck';
    parameters['api_method'] = 'get-truck';
    parameters['truck_id'] = truck_id;

    api_request(parameters, function(response){
        if(response['success']) {
            $("#view_truck_popup").bPopup();
        }
        else {
            alert("Error: Problem opening truck view. Please try again soon.");
        }
    });
}