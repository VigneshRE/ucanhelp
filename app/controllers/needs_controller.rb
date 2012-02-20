class NeedsController < InheritedResources::Base
  belongs_to :orphanage
  before_filter :validate_secret_password, :except => [:show, :index]

  def index
    if params[:orphanage_id]
      index!
    else
      @needs = Need.all
    end
  end

  def validate_secret_password
    orphanage = Orphanage.find_by_id(params[:orphanage_id])
    if session[:secret_password].nil?
      redirect_to :back, :notice => "Please login to do this action"
    elsif session[:secret_password] != orphanage.secret_password
      redirect_to :back, :notice => "You dont have credentials in this orphanage"
    end
  end
end
