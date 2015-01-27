class Uzcommon::Admin::UzadminController < AdminControllerBase  
  before_filter :uzadmin_initialize

  def index
    @collection = @meta.class
    @filter_options = {}

    if @meta.filters.any?
      @meta.filters.each do |f|        
        @filter_options[f.field], @collection = send("apply_#{f.type}_filter", @collection, f)
      end
    else
      @collection = @meta.class.all
    end

    @collection = @collection.order(@meta.sort)
  end

  def apply_select_filter collection, filter
    filter_param = params[filter.field]
    options = { current: filter_param }
    if filter_param and filter_param != 'all'
      collection = collection.where(filter.field => filter_param)
    end
    [options, collection]
  end

  def apply_string_filter collection, filter    
    filter_param = params[filter.field]
    options = { current: filter_param }
    if filter_param and filter_param != ''      
      collection = collection.where("#{filter.field} LIKE ?", "%#{filter_param}%")
    end
    [options, collection]  
  end

  def apply_monthly_filter collection, filter    
    if params[filter.field] and params[filter.field][:year] and params[filter.field][:month]
      year, month = params[filter.field][:year].to_i, params[filter.field][:month].to_i
    else
      year, month = Time.zone.today.year, Time.zone.today.month
    end

    options = { current: Time.zone.local(year, month, 1).at_beginning_of_month }
    
    range = options[:current]..options[:current].at_end_of_month    
    collection = collection.where(filter.field => range)
    
    [options, collection]
  end

  def new    
    @model = @meta.class.new
    @url = uzcommon.admin_uzadmin_create_url(@meta.base_path)
  end

  def edit
    @model = @meta.class.find(params[:id])
    @url = uzcommon.admin_uzadmin_update_url(@meta.base_path, params[:id])
  end

  def create    
    if @meta.can :create
      @model = @meta.class.new(params[@meta.symbol])
      
      if @model.save
        redirect_to uzcommon.admin_uzadmin_index_url(@meta.base_path), notice: "#{@meta.humanized_name} was successfully created."
      else
        render action: "new"
      end    
    end
  end

  def update    
    if @meta.can :edit
      @model = @meta.class.find(params[:id])
      
      if @model.update_attributes(params[@meta.symbol])
        redirect_to uzcommon.admin_uzadmin_index_url(@meta.base_path), notice: "#{@meta.humanized_name} was successfully updated."
      else
        render action: "edit"
      end
    end
  end

  def destroy
    if @meta.can :delete
      @model = @meta.class.find(params[:id])
      @model.destroy
      
      redirect_to uzcommon.admin_uzadmin_index_url(@meta.base_path)    
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
    @meta = UzAdmin::Helpers.find params[:base_path]   
  end
end
