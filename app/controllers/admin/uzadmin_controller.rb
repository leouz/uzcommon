class Admin::UzadminController < AdminControllerBase  
  before_filter :uzadmin_initialize

  def index    
    @collection = @meta.class.order(@meta.sort)
  end

  def new    
    @model = @meta.class.new
    @url = admin_uzadmin_create_url(@meta.base_path)
  end

  def edit
    @model = @meta.class.find(params[:id])
    @url = admin_uzadmin_update_url(@meta.base_path, params[:id])
  end

  def create    
    if @meta.can :create
      @model = @meta.class.new(params[@meta.symbol])
      
      if @model.save
        redirect_to admin_uzadmin_index_url(@meta.base_path), notice: "#{@meta.humanized_name} was successfully created."
      else
        render action: "new"
      end    
    end
  end

  def update    
    if @meta.can :edit
      @model = @meta.class.find(params[:id])
      
      if @model.update_attributes(params[@meta.symbol])
        redirect_to admin_uzadmin_index_url(@meta.base_path), notice: "#{@meta.humanized_name} was successfully updated."
      else
        render action: "edit"
      end
    end
  end

  def destroy
    if @meta.can :delete
      @model = @meta.class.find(params[:id])
      @model.destroy
      
      redirect_to admin_uzadmin_index_url(@meta.base_path)    
    end
  end

  def sort
    @meta.class.all.each do |m|
      m.sort = params[@meta.symbol].index(m.id.to_s) + 1
      m.save
    end

    render :nothing => true
  end 

  private

  def uzadmin_initialize    
    @meta = UzAdmin.find params[:base_path]   
  end
end
