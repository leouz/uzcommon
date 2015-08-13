RSpec::Matchers.define :json_success_schema do |schema, options|
  match do |response|
    @schema_path = "#{SCHEMA_DIRECTORY}/models/#{schema}.json"

    @errors = [] 
    @json_validator_errors = []

    @errors << "response is not successful" unless response.success?

    def validate_schema r
      unless JSON::Validator.validate(@schema_path, r, strict: true)
        @json_validator_errors << JSON::Validator.fully_validate(@schema_path, r, strict: true)
      end
    end

    if options and options[:be_array]
      @errors << "wrong array count" if options[:count] and options[:count] != json_response_array.count
      json_response_array.each { |r| validate_schema r }
    else      
      validate_schema json_response
    end

    !(@errors.any? or @json_validator_errors.any?)
  end

  failure_message do |response|    
    r  = "schema_path: #{@schema_path}\n\n"    
    
    r += "actual status: #{response.status} => #{Rack::Utils::HTTP_STATUS_CODES[response.status]}\n\n"
    r += "actual json: #{json_response_array.pretty_inspect}\n\n"

    r += "errors: \n\n" + @errors.join("\n") + "\n\n" if @errors.any?
    r += "json_validator_errors: #{@json_validator_errors.pretty_inspect}\n\n" if @json_validator_errors.any?
    r
  end
end
