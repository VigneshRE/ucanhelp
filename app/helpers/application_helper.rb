module ApplicationHelper
  def logged_in
    session[:email] != nil and session[:secret_password] != nil
  end

  def current_user
    {:email => session[:email], :secret_password => session[:secret_password]}
  end
  
  def date_field(f, name)
    f.text_field(name, :type => :date, :class => :date)
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, params.merge({:sort => column, :direction => direction}), {:class => css_class}
  end
end
