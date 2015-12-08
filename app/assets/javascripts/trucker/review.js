$(function() {
    addDefaultOptions();
});

var user_history = [];
var user_numeric_history = [];
var currentStage = 0;

var positive_driving = ['Safe Driving', 'Courteous Driving', 'Other'];
var positive_personal = ['Driver was respectful', 'Driver was aware', 'Other'];
var positive = [positive_driving, positive_personal];

var negative_driving = ['Aggressive Driving', 'Reckless Driving', 'Other'];
var negative_personal = ['Driver was rude', 'Driver was inappropriate', 'Other'];
var negative = [negative_driving, negative_personal];

var stage_one = ['What type of review is this?', 'Positive', 'Negative', 'Emergency Situation'];
var stage_two = ['This review pertains to...', 'Driving', 'Behavior'];
var stage_three = ['Please choose a specific reason.', positive, negative];

var stages = [stage_one, stage_two, stage_three];

function selectOption(option) {

    $( "#review-options-container" ).fadeOut( "slow", function() {
        $(".review-option").remove();

        if(option == 2 && currentStage == 0) {
            user_numeric_history[0] = 2;
            $("#review-section-title").text("What do you need to tell the driver?");
            $( "#review-submission-page" ).fadeIn( "slow", function() {
                return true;
            });
        }
        //If option is moving screen forward
        else if(option >= 0 && (currentStage + 1) < stages.length) {
            user_history[currentStage] = stages[currentStage][option + 1];
            user_numeric_history[currentStage] = option;
            currentStage++;
            updateReviewDisplay();
        }
        else if(option < 0){ //Options is going back one screen
            currentStage--;
            updateReviewDisplay();
        }
        else { //Final screen has been reached
            user_history[currentStage] = stages[2][user_numeric_history[0] + 1][user_numeric_history[1]][option];
            user_numeric_history[currentStage] = option;
            currentStage++;
            updateReviewDisplay();
        }
    });

}

function updateReviewDisplay() {

    if(currentStage == stages.length - 1) {
        var displayOptions = '';

        var positive_vs_negative = user_numeric_history[0];
        var driver_vs_personal = user_numeric_history[1];

        var options;

        if(positive_vs_negative == 0) { //positive choice
            if(driver_vs_personal == 0) {
                options = stages[2][1][0];
            }
            else {
                options = stages[2][1][1];
            }
        }
        else { //negative choice
            if(driver_vs_personal == 0) {
                options = stages[2][2][0];
            }
            else {
                options = stages[2][2][1];
            }
        }

        $("#review-section-title").text(stages[currentStage][0]);

        for (var i = 0; i < options.length; i++) {
            displayOptions += '<div class="review-option" onclick="selectOption(' + i + ');">';
            displayOptions += '<span class="option-text">' + options[i] + '</span>';
            displayOptions += '</div>';
        }

        if(currentStage > 0)
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

        if(currentStage > 0)
            displayOptions += '<span onclick="selectOption(-1)">Previous Option</span>';

        $('#review-options-container').html(displayOptions);

        //Fade back in new option
        $( "#review-options-container" ).fadeIn( "slow", function() {

        });
    }
    else {
        $("#review-section-title").text("How would you rate this driver?");
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

    var decision_tree = '';
    if(user_history.length > 1) {
        for (var i = 0; i < 3; i++) {
            decision_tree += user_history[i];

            if (i != 2)
                decision_tree += '/';
        }
    }

    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'truck';
    parameters['api_method'] = 'submit-review';
    parameters['truck_id'] = location.search.split('truck_id=')[1];
    parameters['star_rating'] = $("#rateYo").rateYo("rating");
    parameters['comments'] = $('#review-comment-text').val();
    parameters['decision_tree'] = decision_tree;
    parameters['review_type'] = user_numeric_history[0];
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
}
