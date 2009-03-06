class <%= class_name %> < ActiveRecord::Base
<% attributes.select(&:reference?).each do |attribute| -%>
  belongs_to :<%= attribute.name %>
<% end -%>
  cattr_reader :per_page
  @@per_page = 10
end
