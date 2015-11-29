var stages = [
    ['Positive Review', ['Safe Driving', 'Courteous Behavior']],
    ['Negative Review', ['Reckless Driving', 'Ran me off the road', 'Unprofessional Behavior']],
    ['Emergency Situation', ['Truck Warning', 'Tire Warning', 'Rig Warning']]
];
var currentStage = 0;

$(function() {
    addDefaultOptions();
});

function addDefaultOptions() {
    var defaultElements = '';

    for(var i = 0; i < stages.length; i++) {
        defaultElements += '<div class="review-option" onclick="selectOption(' + i + ');">';
        defaultElements += '<span class="option-text">' + stages[i][0] + '</span>';
        defaultElements += '</div>';
    }

    $('#review-options-container').html(defaultElements);
}

function submitReview(){
    //validate review


    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'truck';
    parameters['api_method'] = 'submit-review';
    parameters['truck_id'] = location.search.split('truck_id=')[1];
    parameters['star_rating'] = $("#rateYo").rateYo("rating");
    parameters['comments'] = $('#review-comment-text').val();
    parameters['decision_tree'] = 'good/ok/best_driver';
    parameters['HTTP_type'] = 'POST';

    alert(parameters['truck_id'] + ' ' + parameters['comments'] + ' ' + parameters['star_rating'] + ' ' + parameters['decision_tree']);

    api_request(parameters, function(response){
        if(response['success']) {
            alert("Review successfully submitted");
        }
        else {
            alert("Error submitting review");
        }
    });
    //send review

    //change to thank you screen
}

function selectOption(option) {

    $( "#review-options-container" ).fadeOut( "slow", function() {

        $(".review-option").remove();

        //If option is moving screen forward
        if(option >= 0) {
            currentStage++;
            var displayOptions = '';
            if (currentStage < 2) {
                var opList = stages[option][1];
                for (var i = 0; i < stages[option][1].length; i++) {
                    displayOptions += '<div class="review-option" onclick="selectOption(' + i + ');">';
                    displayOptions += '<span class="option-text">' + opList[i] + '</span>';
                    displayOptions += '</div>';
                }

                displayOptions += '<span onclick="selectOption(-1)">Previous Option</span>';

                $('#review-options-container').html(displayOptions);
            }
            else {
                $( "#review-submission-page" ).fadeIn( "slow", function() {
                    return true;
                });
                $('#review-options-container').html(displayOptions);
            }
        }
        else { //Options is going back one screen
            currentStage--;
            if(currentStage == 0) {
                addDefaultOptions();
            }

            $('#review-options-container').html(displayOptions);
        }



        $( "#review-options-container" ).fadeIn( "slow", function() {

        });
    });

}