RSpec::Matchers.define :have_json_error do |status, error_fields|  
  match do |response|
    @errors = []    
    
    @errors << "response with a different status code" if response.status != Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
    @errors << "response.body is a json Array" if json_response_array.is_a?(Array)
    @errors << "response doesn't have a message" unless json_response[:message]

    if error_fields
      error_fields.each do |field|
        @errors << "response json doesn't has expected error field: #{field}" unless error_json.has_key?(field)      
      end

      error_json.each do |key, value|
        @errors << "response json has unexpected field: #{key} => #{value}" unless error_fields.include?(field)      
      end
    end

    !@errors.any?
  end

  failure_message do |response|    
    r  = "expected status: #{Rack::Utils::SYMBOL_TO_STATUS_CODE[status]} => #{status}\n\n"
    r += "expected error fields: #{error_fields}\n\n" if error_fields
    r += "actual status: #{response.status} => #{Rack::Utils::HTTP_STATUS_CODES[response.status]}\n\n"
    r += "actual json: #{json_response}\n\n"
    errors = @errors.join("\n")
    r += "errors: #{errors}\n\n"
    r
  end
end
