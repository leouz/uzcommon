module Uzcommon::BsHelper 
  def bs_input f, field_name, type=:string, options={}
    type = :string if type == :email
    options = {} unless options
    options[:field_name] = field_name
    locals = { f: f, field_name: field_name, options: options, type: type }
    if options[:read_only]
      render partial: "fields/read_only_input", locals: locals
    else
      render partial: "fields/input/#{type}", locals: locals
    end
  end

  def bs_actions f, back_path=nil
    render partial: "fields/actions", locals: { f: f, back_path: back_path }
  end
  
  def bs_display type, value, options=nil
    type = :string if [:email, :permalink].include? type    
    type = :boolean if type == :checkbox
    value = "" if value == nil
    if type == :custom      
      render partial: options[:templates][:display], locals: { value: value, options: options }
    else
      render partial: "fields/display/#{type}", locals: { value: value, options: options }
    end
  end

  def bs_table_header field_name, description=nil
    description = field_name.to_s.humanize unless description          
    render partial: "fields/table_header", locals: { field_name: field_name, description: description }
  end

  def bs_search path
    render partial: "fields/search", locals: { path: path }
  end

  def bs_multiple_image_uploader name, all_url, destroy_url, upload_url
    locals = { name: name, multiple: true, all_url: all_url, destroy_url: destroy_url, upload_url: upload_url }
    render partial: "fields/image_uploader", locals: locals
  end

  def bs_filter type, field_name, options, filter_options
    locals = { field_name: field_name, options: options, filter_options: filter_options }
    render partial: "fields/filters/#{type}", locals: locals
  end
end