RSpec.shared_examples "> required params" do |args|  
  
  let (:base_input) do
    base_input = {}
    args[:params].each { |p| base_input[p] = "any" } 
    base_input
  end

  args[:params].each do |missing_one|
    it "misses #{missing_one} param" do
      input = base_input.dup
      input.delete missing_one
      post args[:request_path], input
      expect(response).to have_json_error :bad_request, [missing_one]
    end
  end

  args[:params].each do |missing_one|
    it "misses #{missing_one} param value with nil" do
      input = base_input.dup
      input[missing_one] = nil
      post args[:request_path], input
      expect(response).to have_json_error :bad_request, [missing_one]
    end
  end

  args[:params].each do |missing_one|
    it "misses #{missing_one} param value with empty string" do
      input = base_input.dup
      input[missing_one] = ""
      post args[:request_path], input
      expect(response).to have_json_error :bad_request, [missing_one]
    end
  end

  if args[:params].count > 1
    args[:params].each do |only_one|
      it "misses others b-side #{only_one} param" do
        input = {}
        input[only_one] = "any"

        expect = args[:params].dup
        expect.delete only_one
        
        post args[:request_path], input
        expect(response).to have_json_error :bad_request, expect
      end
    end

    args[:params].each do |only_one|
      it "misses others b-side #{only_one} param without nil" do
        input = base_input.dup
        input.each do |key, value|
          input[key] = nil if key != only_one
        end

        expect = args[:params].dup
        expect.delete only_one
        
        post args[:request_path], input
        expect(response).to have_json_error :bad_request, expect
      end
    end

    args[:params].each do |only_one|
      it "misses others b-side #{only_one} param without empty string" do
        input = base_input.dup      
        input.each do |key, value|
          input[key] = "" if key != only_one
        end

        expect = args[:params].dup
        expect.delete only_one
        
        post args[:request_path], input
        expect(response).to have_json_error :bad_request, expect
      end
    end

    it "misses all params" do
      post args[:request_path], {}
      expect(response).to have_json_error :bad_request, args[:params]
    end

    it "misses all params with nil" do
      input = base_input.dup
      input.each do |key, value|
        input[key] = nil
      end

      post args[:request_path], input
      expect(response).to have_json_error :bad_request, args[:params]
    end

    it "misses all params with empty string" do
      input = base_input.dup    
      input.each do |key, value|
        input[key] = ""
      end

      post args[:request_path], input
      expect(response).to have_json_error :bad_request, args[:params]
    end
  end
end