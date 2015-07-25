require 'spec_helper'
require 'stripe_mock'

class ModelMock
  attr_accessor :attributes
  def initialize attributes
    @attributes = attributes
  end
end

describe "> matchers" do
  context "> default" do
    it "> should pass" do
      expected = ModelMock.new({ test1: "e1", test2: "e2", test3: "e3" })
      actual   = ModelMock.new({ test3: "e3", test2: "e2", test1: "e1" })
      expect(actual).to model_be_equal_to expected
    end

    it "> different attr test3 **raise**" do    
      expected = ModelMock.new({ test1: "e1", test2: "e2", test3: "e3" })
      actual   = ModelMock.new({ test1: "e1", test2: "e2", test3: "changed in actual" })

      expect(actual).to model_be_equal_to expected
    end

    
    it "> expected params **raise**" do
      expected = ModelMock.new({ test1: "e1", test2: "e2", test3: "e3" })
      actual   = ModelMock.new({ test1: "e1", test2: "e2" })

      expect(actual).to model_be_equal_to expected
    end

    it "> outstanding params **raise**" do
      expected = ModelMock.new({ test1: "e1", test2: "e2" })
      actual   = ModelMock.new({ test1: "e1", test2: "e2", test3: "e3" })

      expect(actual).to model_be_equal_to expected
    end
  end

  context "> with except" do    
    it "> different attr" do
      expected = ModelMock.new({ test1: "e1", test2: "e2", test3: "e3" })
      actual   = ModelMock.new({ test1: "e1", test2: "e2", test3: "changed in actual" })

      expect(actual).to model_be_equal_to(expected).except({ test3: "changed in actual" })
    end

    it "> different attr **raise**" do
      expected = ModelMock.new({ test1: "e1", test2: "e2", test3: "e3" })
      actual   = ModelMock.new({ test1: "e1", test2: "e2", test3: "changed in actual" })

      expect(actual).to model_be_equal_to(expected).except({ test3: "changed in actual" })
    end

    it "> not_be_nil attr" do
      expected = ModelMock.new({ test1: "e1", test2: "e2", test3: nil })
      actual   = ModelMock.new({ test1: "e1", test2: "e2", test3: "e3" })

      expect(actual).to model_be_equal_to(expected).except({ test3: :not_be_nil })
    end

    it "> not_be_nil attr **raise**" do
      expected = ModelMock.new({ test1: "e1", test2: "e2", test3: "e3" })
      actual   = ModelMock.new({ test1: "e1", test2: "e2", test3: nil })

      expect(actual).to model_be_equal_to(expected).except({ test3: :not_be_nil })
    end

    it "> not_be_nil with previous nil attr **raise**" do
      expected = ModelMock.new({ test1: "e1", test2: "e2", test3: nil })
      actual   = ModelMock.new({ test1: "e1", test2: "e2", test3: nil })

      expect(actual).to model_be_equal_to(expected).except({ test3: :not_be_nil })
    end

    it "> expected params **raise**" do
      expected = ModelMock.new({ test1: "e1", test2: "e2", test3: "e3" })
      actual   = ModelMock.new({ test1: "e1", test2: "e2" })

      expect(actual).to model_be_equal_to(expected).except({ test3: "e3" })
    end

    it "> outstanding params **raise**" do
      expected = ModelMock.new({ test1: "e1", test2: "e2" })
      actual   = ModelMock.new({ test1: "e1", test2: "e2", test3: "e3" })

      expect(actual).to model_be_equal_to(expected).except({ test3: "e3" })
    end
  end

end