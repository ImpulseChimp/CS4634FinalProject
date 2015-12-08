get_trucks();

function get_trucks() {
    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'truck';
    parameters['api_method'] = 'get-all-trucks';

    api_request(parameters, function(response){
        if (response['success']) {
            loadTrucksIntoView(response['trucks']);
        }
        else{
            alert("Error loading trucks");
        }
    });
}

function loadTrucksIntoView(trucks) {

    var processedTrucks = [];

    var i = 0;
    for (var truck in trucks){
        processedTrucks[i] = trucks[truck];
        i++;
    }

    $( "#site-search-bar" ).autocomplete({
        minLength: 0,
        maxLength: 2,
        source: processedTrucks,
        focus: function( event, ui ) {
            $( "#site-search-bar" ).val( ui.item.label );
            return false;
        },
        source: function(request, response) {
            var results = $.ui.autocomplete.filter(processedTrucks, request.term);
            response(results.slice(0, 5));
        },
        select: function( event, ui ) {
            document.location.href = "http://" + window.location.host + "/" + ui.item.label;
            return false;
        }
    })
        .autocomplete( "instance" )._renderItem = function( ul, item ) {
        return $( "<li>" )
            .append( '<a>' + "<b>" + item.label + "</b>" + "<br>" + item.company_name + "</a>" )
            .appendTo( ul );
    };
}
