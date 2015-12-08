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

$("#create-truck-button").on("click", function() {

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
            alertify.success('Truck Created');

            $('#global_truck_count').text(parseInt($('#global_truck_count').text()) + 1);

            var truckTable = $('#truck-list').DataTable();
            var row = $('<tr>')
                .append('<td>added row</td>')
                .append('<td>Test 2</td>')
                .append('<td>123</td>')
                .append('<td>2014-05-09</td>')
                .append('<td>No</td>')
                .append('<td>blub</td>')

            truckTable.row.add(row);
            $('#truck-table-body').prepend(row);
        }
        else {
            alert("Error: Problem occurred when creating a new truck");
        }
    });
});

