class NeedsController < InheritedResources::Base
  belongs_to :orphanage
  before_filter :validate_secret_password, :except => [:show, :index]
  has_scope :page, :default => 1
  has_scope :severity_type

  def index
    if params[:orphanage_id]
      index!
    else
      @needs = Need.severity_type(params[:severity_type]).page params[:page]
    end
  end

  protected
  def collection
    @needs ||= end_of_association_chain.page params[:page]
  end

  private
  def validate_secret_password
    orphanage = Orphanage.find_by_id(params[:orphanage_id])
    if session[:secret_password].nil?
      redirect_to :back, :notice => "Please login to do this action"
    elsif session[:secret_password] != orphanage.secret_password
      redirect_to :back, :notice => "You dont have credentials in this orphanage"
    end
  end
end
