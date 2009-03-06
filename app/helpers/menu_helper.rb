module MenuHelper
  def menu_builder(active_controller)

    active_item_for_controller = {  
                                    :passwords_controller => :users,
                                    :sessions_controller => nil,
                                    :users_controller => :users,
                                 }

    menu_items = [
#      { :menu_id => :users, :name => 'Usuarios', :url => users_path, :roles => ['responsable de calidad']},
      {:menu_id => nil, :name => 'Menu Example', :url => nil, :roles => ['admin']}
      ]

    content = ""
    first = true
    menu_items.each do |item|
      raise "Tienes que añadir el controlador en el menu helper! helper/menu_helper.rb" unless active_item_for_controller.has_key?(active_controller.to_s.underscore.to_sym)
      if item[:roles].nil? or item[:roles].empty? or current_user.has_role?item[:roles]
        css_class = ""
        if first
          css_class += "first "
          first = false
        end
        if active_item_for_controller[active_controller.to_s.underscore.to_sym] == item[:menu_id]
          css_class += "active"
        end
        
        content += content_tag('li', content_tag('a', item[:name], :href => item[:url] ), :class => css_class) + " "
      end
    end
    content_tag(:ul, content)
  end
end
