class NeedsController < InheritedResources::Base
  helper_method :sort_column, :sort_direction
  belongs_to :orphanage
  before_filter :validate_secret_password, :except => [:show, :index]
  has_scope :page, :default => 1
  has_scope :severity_type
  has_scope :deadline_at
  has_scope :status_is

  def index
    if params[:orphanage_id]
      index!
    else
      @needs = Need.severity_type(params[:severity_type]).deadline_at(params[:deadline_at]).status_is(params[:status_is]).order("#{sort_column} #{sort_direction}").page params[:page]
    end
  end

  def close
    need = Need.find(params[:id])
    need.status = Need::CLOSED
    if need.save
      redirect_to orphanage_need_path(:id => need.id, :orphanage_id => need.orphanage_id), :notice => "Need status successfully changed."
    else
      redirect_to orphanage_need_path(:id => need.id, :orphanage_id => need.orphanage_id), :notice => "Could not change Need status."
    end
  end

  protected
  def collection
    @needs ||= end_of_association_chain.order("#{sort_column} #{sort_direction}").page params[:page]
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

  def sort_column
    Need.column_names.include?(params[:sort]) ? params[:sort] : "deadline"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end
end
