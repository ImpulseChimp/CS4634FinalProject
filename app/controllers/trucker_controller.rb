class TruckerController < ApplicationController

  before_filter :validateAuthToken, :verify_trucker, except: [:trucker_public_profile, :no_truck_found, :review_manager, :review]

  def dashboard
    @truck = get_active_user.truck

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

    @truck.reviews.all.each do |r|
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

      if r.trucker_is_read == 0
        @unread_reviews += 1
      end

    end


    if @truck.reviews.all.size > 0
      @average_score = (@average_score/@truck.reviews.all.size).round(1)
    end

    @positive_review_count = Review.where('review_type=?', 0).all.size
    @negative_review_count = Review.where('review_type=?', 1).all.size
    @neutral_review_count = Review.where('review_type=?', 2).all.size
  end

  def trucker_public_profile
    truck = Truck.where('truck_code=?', params[:truck_id]).first

    if truck.nil?
      truck = Truck.where('truck_license_plate=?', params[:truck_id]).first
    end

    begin
      @truck_img_src = '/assets/truck_default_image.png'
      @company_name = truck.company.company_name
      @truck_id = truck.truck_id
      @license_plate = truck.truck_license_plate
      @truck_code = truck.truck_code

      @review_count = truck.reviews.all.size

      if @review_count > 0
        score_total = 0
        truck.reviews.each do |review|
          score_total += review.review_score
        end

        @star_rating = score_total/@review_count
      else
        @star_rating = 0;
      end

    rescue
      redirect_to no_truck_found_path
    end

  end

  def no_truck_found

  end

  def review

  end

  def review_manager
    @truck_id = params[:truck_id]
  end

end