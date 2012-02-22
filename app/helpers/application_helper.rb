module ApplicationHelper
  def logged_in
    session[:secret_password] != nil
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    if column != "severity"
      css_class = (column == sort_column) ? "current #{sort_direction}" : nil
      direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    else
      css_class = (severity_sort_order == sort_column) ? "current #{sort_direction}" : nil
      direction = (severity_sort_order == sort_column && sort_direction == "asc") ? "desc" : "asc"
    end
    link_to title, params.merge({:sort => column, :direction => direction}), {:class => css_class}
  end
end
