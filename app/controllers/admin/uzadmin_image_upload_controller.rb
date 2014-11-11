class Admin::UzadminImageUploadController < AdminControllerBase
  before_filter :uzadmin_initialize

  def all
    images = @relationship_collection.order("created_at DESC").all
    render :json => images.map { |p| to_image_wrapper_data(p) }
  end

  def create    
    image = @relationship_collection.create({ image: params[:params][@meta.symbol][:image] })
    if image.save          
      render :json => to_image_wrapper_data(image)
    else
      render :json => { :erros => image.errors.full_messages.join(', ').html_safe }, :status => 404
    end
  end

  def destroy
    params[:assets].each{ |p| @relationship_collection.find(p).destroy }
    render :nothing => true
  end

  private 

  def to_image_wrapper_data image
    { :id => image.id, :url => image.image.url, :thumb => image.image_url(:thumb) }
  end

  def uzadmin_initialize    
    @base_meta = UzAdmin::Helpers.find params[:base_path]
    @base_instance = @base_meta.class.find params[:base_id]
    @relationship = @base_meta.find_relationship params[:nested_path]
    @meta = @relationship.meta
    @relationship_collection = @base_instance.send(@relationship.field)    
  end

  def index_url
    admin_uzadmin_nested_index_url(@base_meta.base_path, @base_instance.id)
  end
end