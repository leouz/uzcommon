module UzAdmin
  class Meta      
    class Field
      attr_accessor :name, :type, :options
      attr_accessor :title
      def initialize hash
        @name = hash[:name]
        @type = hash[:type]
        @options = hash[:options]

        @title = hash[:name].to_s.humanize

        if hash[:options]
          @title = hash[:options][:title] if hash[:options][:title]
        end
      end
    end
  end
end