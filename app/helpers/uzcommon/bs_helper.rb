module Uzcommon::BsHelper 
  def bs_input f, field_name, type=:string, options={}
    type = :string if type == :email
    render :partial => "fields/input/#{type}", :locals => { :f => f, :field_name => field_name, :options => options }    
  end

  def bs_actions f, back_path=nil
    render :partial => "fields/actions", :locals => { :f => f, :back_path => back_path }
  end
  
  def bs_display type, value, options=nil
    type = :string if type == :email
    type = :string if type == :select
    type = :string if type == :permalink
    type = :boolean if type == :checkbox
    value = "" if value == nil
    render :partial => "fields/display/#{type}", :locals => { :value => value, :options => options }
  end

  def bs_table_header field_name, description=nil
    description = field_name.to_s.humanize unless description          
    render :partial => "fields/table_header", :locals => { :field_name => field_name, :description => description }
  end

  def bs_search path
    render :partial => "fields/search", :locals => { :path => path }
  end

  def bs_multiple_image_uploader name, all_url, destroy_url, upload_url
    render :partial => "fields/image_uploader", :locals => { name: name, multiple: true, all_url: all_url, destroy_url: destroy_url, upload_url: upload_url }
  end

  def bs_filter type, field_name, options
    render :partial => "fields/filters/#{type}", :locals => { :options => options, :field_name => field_name }
  end
end