module CustomExceptions
  class WrongToken < StandardError
    attr_accessor :token_name
    def initialize token_name
      @token_name = token_name
    end
  end

  class ParamsNotSatisfied < StandardError
    attr_accessor :params
    def initialize params
      @params = params
    end
  end

  class InvalidModelState < StandardError
    attr_accessor :message

    def initialize message
      @message = message      
    end
  end

  class ModelNotValid < StandardError
    attr_accessor :params
    
    def initialize params
      @params = params
    end
  end

  class InvalidParams < StandardError
    attr_accessor :params
    def initialize params
      @params = params
    end
  end

  class EntityNotFound < StandardError
    attr_accessor :entity, :id
    def initialize entity, id
      @id = id
      @entity = entity
    end
  end

  class NotifyAdminError < StandardError
    attr_accessor :message
    def initialize message
      @message = message      
    end
  end
end
