class OrphanagesController < ApplicationController
  inherit_resources
  respond_to :html, :json
  before_filter :validate_secret_password, :only => [:edit, :update, :destroy]
  after_filter :update_session_secret_password, :only => [:update]
  has_scope :page, :default => 1

  protected
  def collection
    @orphanages ||= end_of_association_chain.page params[:page]
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
end