class TruckerController < ApplicationController

  before_filter :validateAuthToken, :verify_trucker, except: [:trucker_public_profile]

  def dashboard

  end

  def trucker_public_profile

  end

end