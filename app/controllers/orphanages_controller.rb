class OrphanagesController < ApplicationController
  helper_method :sort_column, :sort_direction
  inherit_resources
  respond_to :html, :json
  before_filter :validate_secret_password, :only => [:edit, :update, :destroy, :change_secret_password]
  after_filter :update_session_secret_password, :only => [:change_secret_password]
  has_scope :page, :default => 1
  has_scope :admin_verified, :type => :boolean
  has_scope :city_name
  has_scope :nature_is

  def change_secret_password
    return unless request.post?
    @orphanage = Orphanage.find(params[:id])
    respond_to do |format|
      if params[:new_password] == "" or params[:confirmed_new_password] == "" or params[:new_password] != params[:confirmed_new_password]
        format.html  do
          flash.now[:alert] = 'New password did not match with new confirmed password.'
          render :action => "change_secret_password"
        end
      elsif @orphanage.update_attributes({:secret_password => params[:new_password]}, :as => :admin)
        PasswordMailer.change_secret_password(@orphanage).deliver
        format.html  { redirect_to(orphanage_path(@orphanage),
                      :notice => 'Secret Password was successfully updated.') }
        format.json  { head :no_content }
      else
        format.html  { render :action => "change_secret_password" }
        format.json  { render :json => @orphanage.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  def forgot_secret_password
    return unless request.post?
    if !valid_email(params[:email])
      redirect_to forgot_secret_password_orphanage_path(:id => params[:id]), :alert => 'Please provide a valid email address.'
    else
      orphanages = Orphanage.find_all_by_email(params[:email])
      alert = 'There are no care taking homes associated with the given email.'
      if !orphanages.empty?
        PasswordMailer.forgot_secret_password(orphanages).deliver
        notice = 'Secret password has been mailed to your email address successfully.'
      end
      redirect_to orphanage_path(:id => params[:id]), :notice => notice, :alert => alert
    end
  end

  def register
    orphanage = Orphanage.find(params[:id])
    if orphanage.registration_password == params[:registration_password]
      orphanage.registered = true
      if orphanage.save
        flash[:notice] = 'Registration is successfully done.'
      else
        flash[:alert] = 'Registration failed.'
      end
    else
      flash[:alert] = 'Registration password mismatch.'
    end
  end

  protected
  def collection
    @orphanages ||= end_of_association_chain.order("#{sort_column} #{sort_direction}").page params[:page]
  end

  private
  def validate_secret_password
    orphanage = Orphanage.find_by_id(params[:id])
    if session[:secret_password].nil? or session[:email].nil?
      redirect_to orphanage_path(orphanage), :alert => "Please login to do this action"
    elsif session[:secret_password] != orphanage.secret_password or session[:email] != orphanage.email
      redirect_to orphanage_path(orphanage), :alert => "You dont have credentials in this care taking home"
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

  def valid_email(email)
    return false if !email
    return email =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  end
end