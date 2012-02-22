ActiveAdmin.register Orphanage do
  scope :admin_verified
  scope :registered
  controller do
    def update
      @orphanage = Orphanage.find(params[:id])

      respond_to do |format|
        if @orphanage.update_attributes(params[:orphanage], :as => :admin)
          format.html  { redirect_to(admin_orphanage_path(@orphanage),
                        :notice => 'Orphanage was successfully updated.') }
          format.json  { head :no_content }
        else
          format.html  { render :action => "edit" }
          format.json  { render :json => @orphanage.errors,
                        :status => :unprocessable_entity }
        end
      end
    end
  end
end
