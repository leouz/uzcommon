module UzAdmin
  class MetaBuilder
    def initialize selfie
      @hash = { :class => selfie }
      @hash[:filters] = []
      @hash[:fields] = []
      @hash[:relationships] = []
      @hash[:custom_pages] = []
      @hash[:links] = []
    end

    def build
      Meta.new(@hash)
    end

    [:title_field, :index_fields, :populate_batch_count, :sort, :base_path, :can].each do |type|
      define_method type do |value|
        @hash[type] = value
      end
    end

    %w(has_many has_one belongs_to).each do |type|
      define_method type do |field, args={}|
        @hash[:relationships] << { field: field, type: type.to_sym, options: args }
      end
    end

    def filter type, field, args={}
      @hash[:filters] << { type: type, field: field, options: args }
    end

    def custom_page template, args={}
      @hash[:custom_pages] << { template: template, options: args }
    end

    def link name, href, args={}
      @hash[:links] << { name: name, href: href, options: args }
    end

    def fields
      meta_field_builder = MetaFieldBuilder.new()
      yield(meta_field_builder)
      @hash[:fields] = meta_field_builder.fields
    end

    class MetaFieldBuilder
      attr_accessor :fields

      def initialize
        @fields = []
      end

      field_types = %w(custom checkbox email password string currency file)
      field_types += %w(permalink text date image radiogroup time)
      field_types += %w(datetime number select wysi file money integer)
      field_types += %w(color_picker tags view)
      field_types.each do |type|
        define_method type do |name, args={}|
          @fields << { type: type.to_sym, name: name, options: args }
        end
      end
    end
  end
end
