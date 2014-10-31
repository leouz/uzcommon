class Admin::UzadminNestedController < AdminControllerBase  
  before_filter :uzadmin_initialize

  def index    
    @collection = @relationship_collection.order(@meta.sort)
  end

  def new
    @model = @relationship_collection.new
    @url = admin_uzadmin_nested_create_url(@base_meta.base_path, @base_instance.id, @relationship.nested_path)
  end

  def edit
    @model = @relationship_collection.find(params[:nested_id])
    @url = admin_uzadmin_nested_update_url(@base_meta.base_path, @base_instance.id, @relationship.nested_path, params[:nested_id])
  end

  def create
    if @meta.can :create
      @model = @relationship_collection.new(params[@meta.symbol])
      
      if @model.save
        redirect_to index_url, notice: "#{@meta.humanized_name} was successfully created."
      else
        render action: "new"
      end
    end
  end

  def update
    if @meta.can :edit
      @model = @relationship_collection.find(params[:nested_id])
      
      if @model.update_attributes(params[@meta.symbol])
        redirect_to index_url, notice: "#{@meta.humanized_name} was successfully updated."
      else
        render action: "edit"
      end
    end
  end

  def destroy
    if @meta.can :delete
      @model = @relationship_collection.find(params[:nested_id])
      @model.destroy
      
      redirect_to index_url
    end
  end

  def sort
    @relationship_collection.all.each do |m|
      m.sort = params[@meta.symbol].index(m.id.to_s) + 1
      m.save
    end

    render :nothing => true
  end 

  private

  def uzadmin_initialize    
    @base_meta = UzAdmin.find params[:base_path]
    @base_instance = @base_meta.class.find params[:base_id]
    @relationship = @base_meta.find_relationship params[:nested_path]   
    @meta = @relationship.meta
    @relationship_collection = @base_instance.send(@relationship.field)
  end

  def index_url
    admin_uzadmin_nested_index_url(@base_meta.base_path, @base_instance.id)
  end
end
