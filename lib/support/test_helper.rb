module TestHelper
  require 'support/test_helper/user'
  require 'support/test_helper/email'
  include TestHelper::User
  include TestHelper::Email

  def expect_post request_path, request_data={}, sleep=nil
    sleep(sleep) if sleep
    $request_path, $request_data = request_path, request_data
    post $request_path, $request_data

    expect(response)
  end

  def json_response_array
    JSON.parse(response.body)
  end

  def json_response
    JSON.parse(response.body).with_indifferent_access
  end

  #todo transfor into a matcher
  # def expect_have_json_error_response response, status, error_fields
  #   expect(response).to have_http_status status
  #   expect(json_response[:errors].class.to_s).to eq "ActiveSupport::HashWithIndifferentAccess"
  #   error_json = json_response[:errors]    
  #   error_fields.each do |field|
  #     expect(error_json.has_key?(field)).to be true
  #   end
  #   expect(error_json.count).to eql error_json.count
  # end

  #todo transfor into a matcher
  # def expect_to_have_json_model_success_response response, schema
  #   expect(response).to be_success
  #   expect(response).to match_model_response_schema schema    
  # end

  # def expect_to_have_json_model_array_success_response response, schema, options    
  #   expect(response).to be_success
  #   json_response_array.each do |r|
  #     expect(r).to match_model_schema schema    
  #   end        
  #   expect(json_response_array.count).to eq options[:count] if options and options[:count]
  # end

  def all_models
    %w(
      AppError      
      User
    )
  end

  def clear_database
    all_models.each do |model|
      model.constantize.destroy_all    
    end    
  end

  def app_uri *paths
    paths.join "/"
  end
end