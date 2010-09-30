class FkGeneratorGenerator < Rails::Generator::NamedBase
  attr_accessor :relations
  attr_accessor :klass

  def manifest
    begin
      record do |m|
        path = args.shift
        add = args.shift
        base_name = File.basename(path, File.extname(path)).gsub(/ /, '_').downcase 
        class_name = base_name.classify()
        @klass = class_name.constantize

        @relations = @klass.reflect_on_all_associations.select {|x| x.macro == :belongs_to}.collect {|association|
          related_class_name = association.options[:class_name] || association.name.to_s.camelize
          key_name = association.primary_key_name
          table_name = related_class_name.constantize.table_name
          {
            :column => key_name,
            :table => table_name,
            :constraint_name => "#{@klass.table_name}_fk_#{table_name}_#{key_name}",
          }
        }.compact

        m.migration_template 'migration.rb', 'db/migrate'
      end
    rescue Exception => e
      puts "script/generate fk_generator Model path/to/model"
      raise e
    end
  end
end
