class CompanyController < ApplicationController

  before_filter :validateAuthToken, :verify_company

  def dashboard
    @company = get_active_user.company
  end

  def review_manager
    @company = get_active_user.company

    @average_score = 0

    @company.reviews.all.each do |r|
      @average_score += r.review_score
    end

    @average_score = (@average_score/@company.reviews.all.size).round(1)

    @positive_review_count = 5;
    @negative_review_count = 3;
    @neutral_review_count = 9;
  end

  def truck_manager

  end

end