class CommentsController < ApplicationController
  def create
    @need = Need.find(params[:need_id])
    @comment = @need.comments.create(params[:comment])
    redirect_to orphanage_need_path(:orphanage_id => @need.orphanage_id, :id => @need.id)
  end

  def destroy
    @need = Need.find(params[:need_id])
    @comment = @need.comments.find(params[:id])
    @comment.destroy
    redirect_to orphanage_need_path(:orphanage_id => @need.orphanage_id, :id => @need.id)
  end
end
