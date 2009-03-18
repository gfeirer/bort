module ThLinksHelper
  def self.included(target)
    target.send :include, InstanceMethods
  end

  module InstanceMethods
    def th_link(title, column_name, current_order, html_options = {})
      image_column_order_tag = ""
      if current_order && current_order.include?(column_name)
        if current_order.include? " DESC"
          image_column_order_tag = image_tag "column_order_desc.png"
        else
          image_column_order_tag = image_tag "column_order_asc.png"
        end
      end
      th = ""
      th += "<th nowrap"
      html_options.each do |key, value|
        th += " " + key.to_s + '="' + value.to_s + '"'
      end
      if column_name
        th += ">"
        th += link_to title+image_column_order_tag, {:controller => controller.controller_name, :action => controller.action_name, :order => ((current_order == column_name.to_s && (column_name.to_s + " DESC")) || column_name.to_s)}
        th += "</th>"
      else
        th += " />"
      end
    end
  end
end
