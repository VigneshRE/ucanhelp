class OrphanagesController < ApplicationController
  helper_method :sort_column, :sort_direction
  inherit_resources
  respond_to :html, :json
  before_filter :validate_secret_password, :only => [:edit, :update, :destroy]
  after_filter :update_session_secret_password, :only => [:update]
  has_scope :page, :default => 1
  has_scope :admin_verified, :type => :boolean

  protected
  def collection
    @orphanages ||= end_of_association_chain.order("#{sort_column} #{sort_direction}").page params[:page]
  end

  private
  def validate_secret_password
    orphanage = Orphanage.find_by_id(params[:id])
    if session[:secret_password].nil?
      redirect_to orphanage_path(orphanage), :notice => "Please login to do this action"
    elsif session[:secret_password] != orphanage.secret_password
      redirect_to orphanage_path(orphanage), :notice => "You dont have credentials in this orphanage"
    end
  end

  def update_session_secret_password
    orphanage = Orphanage.find_by_id(params[:id])
    session[:secret_password] = orphanage.secret_password
  end

  def sort_column
    Orphanage.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end
end