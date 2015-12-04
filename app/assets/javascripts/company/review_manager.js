function viewReviewPopup(review_id) {
    $(".view_review_popup_input").val("");

    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'company';
    parameters['api_method'] = 'get-review';
    parameters['review_id'] = review_id;

    api_request(parameters, function(response){
        if(response['success']) {
            $("#popup_review_text").val(response['review_comment']);
            $("#view_review_popup").bPopup();
        }
        else {
            alert("Error: Problem opening review. Please try again soon.");
        }
    });
}