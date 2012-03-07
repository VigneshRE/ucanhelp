class HomeController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    if params[:orphanage_id]
      index!
    else
      @needs = Need.severity_type(params[:severity_type]).order("#{sort_column} #{sort_direction}").page params[:page]
    end
  end

  def sort_column
    Need.column_names.include?(params[:sort]) ? params[:sort] : "deadline"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end
end