class CommentsController < ApplicationController
  def create
    @need = Need.find(params[:need_id])
    @need.comments.create(params[:comment])
    redirect_to orphanage_need_path(:orphanage_id => @need.orphanage_id, :id => @need.id)
  end
end
