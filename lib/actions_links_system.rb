module ActionsLinksSystem
  def self.included(target)
    target.send :extend, ClassMethods
  end

  module ClassMethods
    def action_options(action)
      commons_options[action] ? commons_options[action].merge(custom_actions_options[action] || {}) : custom_actions_options[action] || {}
    end

    def actions_options
      commons_options.merge(custom_actions_options || {})
    end

    def actions_order
      common_actions_order + custom_actions_order
    end

    private

    def custom_actions_options
      {}
    end

    def custom_actions_order
      []
    end

    def commons_options
      {
        :index => {:name => "Volver al listado", :hide => true, :options => {:id => nil}},
        :new => {:name => "Nuevo", :hide => true, :options => {:id => nil}},
        :show => {:name =>"Mostrar"},
        :edit => {:name => "Editar"},
        :destroy => {:name => "Borrar", :html_options => {:method => :delete, :confirm => '¿Está seguro que desea borrar?'}}
      }
    end

    def common_actions_order
      [
        :destroy,
        :delete,
        :edit,
        :show
      ]
    end
  end
end
