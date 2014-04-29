module Uzcommon::BsHelper 
  def bs_field(f, field_name, type=:text, options={})
    render :partial => "fields/input_#{type}", :locals => { :f => f, :field_name => field_name, :options => options }    
  end

  def bs_actions (f, back_path=nil)
    render :partial => "fields/actions", :locals => { :f => f, :back_path => back_path }
  end

  def bs_display (type, options)
    render :partial => "fields/display_#{type}", :locals => { :options => options }
  end
end