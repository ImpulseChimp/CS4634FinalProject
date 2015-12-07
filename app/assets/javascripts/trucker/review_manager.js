function viewReviewPopup(review_id) {
    $(".view_review_popup_input").val("");

    var parameters = {};
    parameters['version'] = 'v1';
    parameters['api_name'] = 'company';
    parameters['api_method'] = 'get-review';
    parameters['review_id'] = review_id;

    api_request(parameters, function(response){
        if(response['success']) {
            $("#popup_reviewer_name").text(response['reviewer_name']);
            $("#popup_reviewer_email").text(response['reviewer_email']);
            $("#popup_review_type").text(response['review_type']);
            $("#popup_review_tree").text(response['review_tree']);
            $("#popup_review_text").val(response['review_comment']);
            $("#view_review_popup").bPopup();
            $("#" + review_id + "_is_read").text("Yes");
        }
        else {
            alert("Error: Problem opening review. Please try again soon.");
        }
    });
}