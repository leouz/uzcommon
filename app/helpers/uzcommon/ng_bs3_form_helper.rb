module NgBs3FormHelper
  def ng_bs3_form_for name_tag='form', &block
    locals = { options: { name_tag: name_tag, control_type: :form_for }, block: block }
    render partial: "ng_bs3_form_helpers/form-public", locals: locals    
  end

  def ng_bs3_input ng_model, type=:string, options={}, &block
    options[:ng_model] = ng_model
    options[:type] = type

    options[:wrapper_type] = :with_label
    options[:control_type] = :input
    
    options = normalize_options options    
    render partial: "ng_bs3_form_helpers/form-public", locals: { options: options, block: block }
  end

  private

  def normalize_options options
    options = options || {}

    if options[:type] == :radio and options[:wrapper_type] == :with_label
      options[:wrapper_type] = :with_label_for_radio 
    end
    
    if options[:ng_model] != nil and options[:model] == nil and options[:field] == nil
      split = options[:ng_model].split(".")
      options[:model] = split[0]
      options[:field] = split[1]
    else
      options[:model] = options[:model] || "model"
      options[:field] = options[:field] || "field"
      options[:ng_model] = options[:ng_model] || "#{options[:model]}.#{options[:field]}"
    end

    options[:html] = options[:html] || {}

    options[:type] = options[:type] || :string
    options[:label] = options[:label] || options[:field].humanize     
    options[:required] = options[:required] == nil ? true : false

    options[:server_validation] = options[:server_validation] == nil ? true : false

    options[:form_name] = options[:form_name] || 'form'
    options[:id_tag] = "#{options[:model]}_#{options[:field]}"
    options[:name_tag] = options[:name_tag] || options[:field]
    
    options
  end
end
