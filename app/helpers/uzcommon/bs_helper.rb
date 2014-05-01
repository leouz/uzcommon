module Uzcommon::BsHelper 
  def bs_input f, field_name, type=:text, options={}
    render :partial => "fields/input/#{type}", :locals => { :f => f, :field_name => field_name, :options => options }    
  end

  def bs_actions f, back_path=nil
    render :partial => "fields/actions", :locals => { :f => f, :back_path => back_path }
  end
  
  def bs_display  type, value, options=nil
    render :partial => "fields/display/#{type}", :locals => { :value => value, :options => options }
  end

  def bs_table_header field_name, description=nil
    description = field_name.to_s.humanize unless description          
    render :partial => "fields/table_header", :locals => { :field_name => field_name, :description => description }
  end

  def bs_search path
    render :partial => "fields/search", :locals => { :path => path }
  end
end