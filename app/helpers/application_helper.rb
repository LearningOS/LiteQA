module ApplicationHelper
  def tailwind_classes_for(flash_type)
    {
      info: "alert-info",
      notice: "alert-success",
      error: "alert-error",
      alert: "alert-warning",
      warning: "alert-warning"
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

end
