RSpec::Matchers.define :json_success_schema do |schema, options|
  match do |response|
    @schema_path = "#{SCHEMA_DIRECTORY}/models/#{schema}.json"

    @errors = [] 
    @json_validator_errors = []

    @errors << "response is not successful" if response.success?


    def validate_schema
      unless JSON::Validator.validate(@schema_path, response, strict: true)
        @json_validator_errors << JSON::Validator.fully_validate(@schema_path, response, strict: true)
      end
    end

    if options[:be_array]
      @errors << "wrong array count" if options[:count] and options[:count] != json_response_array.count
      json_response_array.each { |r| validate_schema r }
    else      
      validate_schema json_response
    end

    !(@errors.any? or @json_validator_errors.any?)
  end

  failure_message do |response|    
    r  = "schema_path: @schema_path\n\n"    
    r += "actual status: #{response.status} => #{Rack::Utils::HTTP_STATUS_CODES[response.status]}\n\n"
    r += "actual json: #{json_response_array.pretty_inspect}\n\n"
    errors = @errors.join("\n")
    r += "errors: #{errors}\n\n"
    r += "json_validator_errors: #{@json_validator_errors.pretty_inspect}\n\n"
    r
  end
end
