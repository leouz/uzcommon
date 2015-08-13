RSpec::Matchers.define :have_json_error do |status, error_fields, options|  
  match do |response|
    @errors = []    
    @options = options ? options : []
    
    @errors << "response with a different status code" if response.status != Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
    @errors << "response.body is a json Array" if json_response_array.is_a?(Array)
    if options and options[:has_message]
      @errors << "response doesn't have a message" unless json_response[:message] 
    else
      @errors << "response have a message" if json_response[:message]
    end

    if error_fields      
      unless json_response[:errors]
        @errors << "'errors' param didn't found in response" 
      else
        error_fields.each do |field|
          @errors << "response json doesn't has expected error field: #{field}" unless json_response[:errors].has_key?(field)
        end

        json_response[:errors].each do |key, value|
          @errors << "response json has unexpected field: #{key} => #{value}" unless error_fields.map{ |i| i.to_s }.include?(key.to_s)      
        end
      end
    end

    !@errors.any?
  end

  failure_message do |response|    
    r  = "expected status: #{Rack::Utils::SYMBOL_TO_STATUS_CODE[status]} => #{status}\n\n"
    r += "expected error fields: #{error_fields}\n\n" if error_fields
    r += "actual status: #{response.status} => #{Rack::Utils::HTTP_STATUS_CODES[response.status]}\n\n"
    r += "actual json: #{json_response_array}\n\n"
    errors = @errors.join("\n")
    r += "errors: #{errors}\n\n"
    r
  end
end
