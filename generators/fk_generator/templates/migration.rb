class <%= class_name.underscore.camelize %> < ActiveRecord::Migration
  def self.up
    <%- for relation in relations -%>
      execute "ALTER TABLE <%= klass.table_name %> ADD CONSTRAINT <%= relation[:constraint_name] -%> FOREIGN KEY (<%= relation[:column]%>) REFERENCES <%= relation[:table] %>(id)"
    <%- end -%>
  end

  def self.down
  <% for relation in relations -%>
    execute "alter table <%= klass.table_name %> DROP CONSTRAINT <%= relation[:constraint_name]%>"
  <% end -%>
  end
end
