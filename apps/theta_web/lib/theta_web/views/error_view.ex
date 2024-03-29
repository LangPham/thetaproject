defmodule ThetaWeb.ErrorView do
  use ThetaWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  #   def render("500.html", _assigns) do
  #     "Internal Server Error"
  #   end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  #  def render( "404.html", conn) do
  #
  #   "Page not found"
  #  end

  def render("500.html", _assigns) do
    "Server internal error"
  end

  #  def render("403.html", _assigns) do
  #    "KIem tra 403"
  #  end

  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
