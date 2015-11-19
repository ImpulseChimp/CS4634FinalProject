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

function selectOption(option) {

    $( "#review-options-container" ).fadeOut( "slow", function() {

        $(".review-option").remove();

        //If option is moving screen forward
        if(option >= 0) {
            var displayOptions = '';
            if (currentStage < 2) {
                var opList = stages[option][1];
                for (var i = 0; i < stages[option][1].length; i++) {
                    displayOptions += '<div class="review-option" onclick="selectOption(' + i + ');">';
                    displayOptions += '<span class="option-text">' + opList[i] + '</span>';
                    displayOptions += '</div>';
                }

                displayOptions += '<span onclick="selectOption(-1)">Previous Option</span>';
            }
            else {
                displayOptions = "FINAL SCREEN REACHED";
            }
            currentStage++;
        }
        else { //Options is going back one screen
            currentStage--;
        }

        $('#review-options-container').html(displayOptions);

        $( "#review-options-container" ).fadeIn( "slow", function() {
            // Animation complete.
        });
    });

}