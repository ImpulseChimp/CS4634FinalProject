class CommuterController < ApplicationController

  before_filter :verify_commuter

  def dashboard
    @user = get_active_user
    @reviews = @user.reviews
  end

  def reviews
    @reviews = get_active_user.reviews

    @positive_review_count = 0
    @negative_review_count = 0
    @neutral_review_count = 0
    @average_score = 0

    @reviews.all.each do |r|
      # Computer average score
      @average_score += r.review_score

      if r.review_type == 0
        @positive_review_count += 1
      elsif r.review_type == 1
        @negative_review_count += 1
      else
        @neutral_review_count += 1
      end

    end
  end

end