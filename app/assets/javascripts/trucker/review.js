$(function() {
    addDefaultOptions();
});

var user_history = [];
var currentStage = 0;

var positive_driving = ['Good driver', 'other driving things', 'more driving things'];
var positive_personal = ['Good driver', 'other personal things', 'more personal things'];
var positive = [positive_driving, positive_personal];

var negative_driving = ['Bad driver', 'other driving things', 'more driving things'];
var negative_personal = ['Bad personal', 'other personal things', 'more personal things'];
var negative = [negative_driving, negative_personal];

var stage_one = ['This review is...', 'Positive', 'Negative', 'Emergency Situation'];
var stage_two = ['This review is about', 'Truckers Driving', 'The Trucker Personally'];
var stage_three = ['Please choose a specific reason', positive, negative];

var stages = [stage_one, stage_two, stage_three];

function selectOption(option) {

    $( "#review-options-container" ).fadeOut( "slow", function() {
        $(".review-option").remove();

        //If option is moving screen forward
        if(option >= 0 && (currentStage + 1) < stages.length) {
            user_history[currentStage] = stages[currentStage][option + 1];
            currentStage++;
            updateReviewDisplay();
        }
        else if(option < 0){ //Options is going back one screen
            currentStage--;
            updateReviewDisplay();
        }
        else { //Final screen has been reached
            currentStage++;
            updateReviewDisplay();
        }
    });

}

function updateReviewDisplay() {

    if(currentStage == stages.length - 1) {
        var displayOptions = '';

        $("#review-section-title").text(stages[currentStage][0]);

        for (var i = 0; i < (stages[2][1][0].length); i++) {
            displayOptions += '<div class="review-option" onclick="selectOption(' + i + ');">';
            displayOptions += '<span class="option-text">' + stages[2][1][0][i] + '</span>';
            displayOptions += '</div>';
        }

        displayOptions += '<span onclick="selectOption(-1)">Previous Option</span>';

        $('#review-options-container').html(displayOptions);

        //Fade back in new option
        $( "#review-options-container" ).fadeIn( "slow", function() {

        });
    }
    else if(currentStage < stages.length) {
        var displayOptions = '';

        //Update section name here
        $("#review-section-title").text(stages[currentStage][0]);

        for (var i = 0; i < (stages[currentStage].length - 1); i++) {
            displayOptions += '<div class="review-option" onclick="selectOption(' + i + ');">';
            displayOptions += '<span class="option-text">' + stages[currentStage][i + 1] + '</span>';
            displayOptions += '</div>';
        }

        displayOptions += '<span onclick="selectOption(-1)">Previous Option</span>';

        $('#review-options-container').html(displayOptions);

        //Fade back in new option
        $( "#review-options-container" ).fadeIn( "slow", function() {

        });
    }
    else {
        alert(user_history);
        $( "#review-submission-page" ).fadeIn( "slow", function() {
            return true;
        });
        $('#review-options-container').html(displayOptions);
    }

}


function addDefaultOptions() {
    var defaultElements = '';
    $("#review-section-title").text(stages[currentStage][0]);

    for(var i = 0; i < (stages[0].length - 1) ; i++) {
        defaultElements += '<div class="review-option" onclick="selectOption(' + i + ');">';
        defaultElements += '<span class="option-text">' + stages[0][i + 1] + '</span>';
        defaultElements += '</div>';
    }

    $('#review-options-container').html(defaultElements);
}

function submitReview(){

    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'truck';
    parameters['api_method'] = 'submit-review';
    parameters['truck_id'] = location.search.split('truck_id=')[1];
    parameters['star_rating'] = $("#rateYo").rateYo("rating");
    parameters['comments'] = $('#review-comment-text').val();
    parameters['decision_tree'] = 'good/ok/best_driver';
    parameters['HTTP_type'] = 'POST';

    api_request(parameters, function(response){
        if(response['success']) {
            $( "#review-submission-page" ).fadeOut( "slow", function() {
                $( "#review-completed-container" ).fadeIn( "slow", function() {

                });
            });
        }
        else {
            alert("Error submitting review");
        }
    });
    //send review

    //change to thank you screen
}