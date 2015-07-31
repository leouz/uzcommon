SCHEMA_DIRECTORY = "#{Dir.pwd}/spec/support/schemas"

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

