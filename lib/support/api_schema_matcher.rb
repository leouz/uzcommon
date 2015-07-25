SCHEMA_DIRECTORY = "#{Dir.pwd}/spec/support/schemas"

# RSpec::Matchers.define :have_json_model_success_response do |schema|
#   match do |response|
#     expect(response).to be_success
# 		expect(response).to match_model_response_schema schema
#   end
# end

# RSpec::Matchers.define :have_json_error_response do |status, error_fields|
#   match do |response|
#     expect(response).to have_http_status status
#     expect(json_response[:errors].class.to_s).to eq("ActiveSupport::HashWithIndifferentAccess")
#     error_json = json_response[:errors]
#     error_fields.each do |field|
# 		  expect(error_json.has_key?(field)).to (true)
#     end
#     expect(error_json.count).to eql error_json.count
#   end
# end

RSpec::Matchers.define :match_model_schema do |schema|
  match do |response|
    schema_path = "#{SCHEMA_DIRECTORY}/models/#{schema}.json"
    JSON::Validator.validate!(schema_path, response, strict: true)
  end
end

RSpec::Matchers.define :match_response_schema do |schema|
  match do |response|
    schema_path = "#{SCHEMA_DIRECTORY}/#{schema}.json"
    JSON::Validator.validate!(schema_path, response.body, strict: true)
  end
end

RSpec::Matchers.define :match_model_response_schema do |schema|
  match do |response|
    schema_path = "#{SCHEMA_DIRECTORY}/models/#{schema}.json"
    JSON::Validator.validate!(schema_path, response.body, strict: true)
  end
end

RSpec::Matchers.define :match_model_error_response_schema do |schema|
  match do |response|
    model = JSON.parse File.read "#{SCHEMA_DIRECTORY}/models/#{schema}.json"
    model_error = JSON.parse File.read "#{SCHEMA_DIRECTORY}/model_error_response.json"

    # TODO: mix both in a proper way
    model_error[:model] = model

    JSON::Validator.validate!(schema_path, response.body, strict: true)
  end
end

# RSpec.configure do |config|
#   config.expect_with :rspec do |c|
#     c.include_chain_clauses_in_custom_matcher_descriptions = true
#   end
# end

RSpec::Matchers.define :model_be_equal_to do |expected|
  match do |actual|
    @except_attrs = {} if @except_attrs == nil

    if expected.is_a?(Hash)
      @expected_attrs = expected 
    else
      @expected_attrs = expected.attributes
    end

    if actual.is_a?(Hash)
      @actual_attrs = actual 
    else
      @actual_attrs = actual.attributes
    end

    @except_attrs = @except_attrs.keys_to_strings
    
    @errors = []

    @expected_attrs.each do |key, value|
      @errors << "expected param: #{key} not found in actual" if !@actual_attrs.has_key? key
    end

    @actual_attrs.each do |key, value|
      @errors << "outstanding param: #{key} found in actual" if !@expected_attrs.has_key? key
    end

    def format_value value
      if is_some_kind_of_date(value)
        value.strftime "%Y-%m-%d %H:%M:%S:%L:%N %Z"
      else
        value
      end
    end

    def is_some_kind_of_date value
      value.is_a?(Date) or value.is_a?(DateTime) or value.is_a?(Time)
    end

    unless @errors.any?
      @expected_attrs.each do |key, expected_value|
        error = nil        
        if @except_attrs.has_key?(key)
          unless @except_attrs[key] == :ignore
            if @except_attrs[key] == :changed
              error = "expected param to bem changed but is equal previous or nil" if @actual_attrs[key] == nil or @actual_attrs[key] == expected_value
            elsif @except_attrs[key] == :recent
              e = ""
              e += "except param expected to be recent, but the actual value isn't a date" unless is_some_kind_of_date @actual_attrs[key]
              e += "except param expected to be recent, but the expected value isn't a date" unless is_some_kind_of_date expected_value
              if e == ""
                error = "except param expected to be recent but isnt't" if @actual_attrs[key] <= expected_value
              else
                error = e
              end
            elsif @except_attrs[key] == :not_be_nil_anymore
              e = ""              
              e += "except param expected to not be nil ANYMORE but it is" if @actual_attrs[key] == nil
              e += "except param expected to not be nil ANYMORE but it wasn't" if @expected_attrs[key] != nil
              error = e if e != ""
            elsif @except_attrs[key] == :not_be_nil
              error = "except param expected to not be nil but it is" if @actual_attrs[key] == nil
            elsif @except_attrs[key] == expected_value
              error = "except param expected to have change it's value but didn't"  
            elsif @except_attrs[key] != @actual_attrs[key]              
              error = "except param expected"
            end
          end
        elsif @actual_attrs[key] != expected_value
          error = "expected"          
        end

        if error          
          error += "\n    #{key} => expected: #{format_value(expected_value)} | actual: #{format_value(@actual_attrs[key])}"
          error += " | except: #{format_value(@except_attrs[key])}" if @except_attrs.has_key?(key)
          error += "\n\n"                
          @errors << error
        end
      end      
    end    

    !@errors.any?
  end

  chain :except do |except_attrs|
    @except_attrs = except_attrs
  end

  failure_message do |actual|
    e = @errors.join("\n")
    if @except_attrs != {}
      "expected: #{@expected_attrs}\n\n  actual: #{@actual_attrs}\n\n  except: #{@except_attrs}\n\n#{e}\n\n"
    else
      "expected: #{@expected_attrs}\n\n  actual: #{@actual_attrs}\n\n#{e}\n\n"
    end
  end
end
