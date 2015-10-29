class AdminController < ApplicationController

  before_filter :validateAdminAuthToken, :except => :login

  def login

  end

  def user_manager

  end

  def dashboard

  end

  def documentation

  end

  def validateAdmin
    return true
  end

  private :validateAdmin

end