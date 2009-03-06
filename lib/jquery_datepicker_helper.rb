module JqueryDatepickerHelper
  def self.included(target)
    target.send :include, InstanceMethods
  end

  module InstanceMethods
    def jquery_datepickers(fields)
      r = "<script type=\"text/javascript\">" + "\n"
      r += "$(function() {" + "\n"
      for field in fields
        r += "$(\"##{field}\").datepicker({showOn: 'button', buttonImage: '/images/calendar.gif', buttonImageOnly: true});" + "\n"
      end
      r += "});" + "\n"
      r += "</script>" + "\n"
    end
  end
end
