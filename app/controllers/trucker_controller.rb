class TruckerController < ApplicationController

  before_filter :validateAuthToken, :verify_trucker

  def dashboard

  end

end