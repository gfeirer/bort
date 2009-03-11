module ActionsLinksHelper
  def self.included(target)
    target.send :include, InstanceMethods
  end

  module InstanceMethods
    def formatted_option_links(controller, instance, options = {}, custom_links = [], custom_order = nil)
      formatted_links(actions_links_for_current_user(controller, instance, options, custom_links, custom_order))
    end

    def formatted_links(links)
      links.join("&nbsp;|&nbsp;")
    end

    def actions_links_for_current_user(controller, instance, options = {}, custom_links = [], custom_order = nil)
      possible_actions_array = instance.methods.include?("aasm_events_for_current_state") ? instance.aasm_events_for_current_state : []
      possible_actions_array += [:show, :edit, :destroy]

      order = custom_order || controller.actions_order

      actions_links = []

      order.each do |action|
        if possible_actions_array.include?(action)
          actions_links << action_link(controller, instance, action, options[action])
          options.delete(action)
          possible_actions_array.delete(action)
        end
      end

      possible_actions_array.each do |action|
        actions_links << action_link(controller, instance, action, options[action])
        options.delete(action)
      end

      options.each  do |action, options|
        actions_links << action_link(controller, instance, action, options)
      end

      (actions_links + custom_links).compact.reverse
    end

    def array_actions_links_for_current_user(controller, instances, options = {}, custom_links = [], custom_order = nil)
      order = custom_order || controller.actions_order

      array_actions_links = []
      instances.each do |instance|
        instance.aasm_events_for_current_state.each do |event|
          order << event unless order.include?(event)
        end
        array_actions_links << actions_links_for_current_user(controller, instance, options, custom_links, order)
      end

      array_actions_links
    end

    protected
    def action_link(controller, instance, action, options)
      action_options = (controller.action_options(action) || {}).merge(options || {})
      controller = action_options[:controller] if action_options[:controller]
      action = action_options[:action] if action_options[:action]

      if !action_options.blank? && action_options[:hide].blank? && (controller.user_authorized_for?(current_user, {:action => action}, binding) rescue true)
        link_to_name = action_options[:name] ? action_options[:name] : action.to_s.humanize
        default_link_to_options = {:controller => controller.controller_name, :action => action, :id => instance.id}
        link_to_options = action_options[:options] ? default_link_to_options.merge(action_options[:options]) : default_link_to_options

        if id_instance = link_to_options.index(:id_instance)
          link_to_options[id_instance] = instance.id
        end

        link_to(link_to_name, link_to_options, action_options[:html_options])
      else
        nil
      end
    end
  end
end
