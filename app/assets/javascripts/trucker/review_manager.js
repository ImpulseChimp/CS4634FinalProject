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
            $("#popup_review_date").text(response['created_at']);
            $("#popup_review_type").text(response['review_type']);
            $("#popup_review_tree").text(response['review_tree']);
            $("#popup_review_text").text(response['review_comment']);
            $("#star_review_value").text(response['review_score']);
            $("#star_review").rateYo({
                rating: response['review_score'],
                starWidth: "50px",
                readOnly: true
        });
            $("#view_review_popup").bPopup();
        }
        else {
            alert("Error: Problem opening review. Please try again soon.");
        }
    });
}
