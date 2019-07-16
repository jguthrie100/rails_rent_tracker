module TransactionHelper
  def filter_link filter
    "#{@filters[filter]}&nbsp;#{link_to "<i class=\"far fa-times-circle\"></i>".html_safe, transactions_path(@filters.except(filter))}".html_safe if @filters[filter]
  end
end
