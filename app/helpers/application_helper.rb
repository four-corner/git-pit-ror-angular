module ApplicationHelper
  def ar_errors_custom_view(ar_obj)
    return "" if ar_obj.errors.empty?
    messages = ar_obj.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
      <div class="alert alert-error alert-block">
        <button class="close" data-dismiss="alert" type="button">
          x
        </button>
        <div class="alert alert-danger">
          <ul>
            #{messages}
          </ul>
        </div>
      </div>
    HTML

    html.html_safe
  end
end
