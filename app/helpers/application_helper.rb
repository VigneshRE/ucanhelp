module ApplicationHelper
  def logged_in
    session[:secret_password] != nil
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
