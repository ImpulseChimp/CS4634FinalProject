class CompanyController < ApplicationController

  before_filter :validateAuthToken, :verify_company

  def dashboard
    @company = get_active_user.company
  end

  def review_manager
    @company = get_active_user.company

    @average_score = 0

    @reviews_by_day = []
    @positive_by_day = []
    @negative_by_day = []
    @other_by_day = []

    i = 0
    while i < 26 do
      @reviews_by_day[i] = 0
      @positive_by_day[i] = 0
      @negative_by_day[i] = 0
      @other_by_day[i] = 0
      i += 1
    end

    current_month = Date.today.strftime('%m').to_i

    @unread_reviews = 0

    @company.reviews.all.each do |r|
      # Computer average score
      @average_score += r.review_score

      # Compute review by date
      date = DateTime.parse(r.created_at.to_s)
      day = date.strftime('%d').to_i
      month = date.strftime('%m').to_i

      if month == current_month
        @reviews_by_day[day - 1] += 1
      end

      if r.review_type == 0
        @positive_by_day[day - 1] += 1
      elsif r.review_type == 1
        @negative_by_day[day - 1] += 1
      else
        @other_by_day[day - 1] += 1
      end

      if r.company_is_read == 0
        @unread_reviews += 1
      end

    end


    if @company.reviews.all.size > 0
      @average_score = (@average_score/@company.reviews.all.size).round(1)
    end

    @positive_review_count = 5;
    @negative_review_count = 3;
    @neutral_review_count = 9;
  end

  def truck_manager
    @company = get_active_user.company

    @positive_review_count = 5;
    @negative_review_count = 3;
    @neutral_review_count = 9;
  end

end