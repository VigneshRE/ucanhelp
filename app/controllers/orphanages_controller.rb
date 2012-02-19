class OrphanagesController < ApplicationController
  inherit_resources
  respond_to :html, :json
  before_filter :validate_secret_password, :only => [:edit, :update, :destroy]

  def validate_secret_password
    orphanage = Orphanage.find_by_id(params[:id])
    if session[:secret_password].nil?
      redirect_to orphanage_path(orphanage), :notice => "Please login to do this action"
    elsif session[:secret_password] != orphanage.secret_password
      redirect_to orphanage_path(orphanage), :notice => "You dont have credentials in this orphanage"
    end
  end
end