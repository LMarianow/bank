module ApplicationHelper
    def active_menu(controller, method)
        "current" if controller == controller_name && method == action_name
    end
end
