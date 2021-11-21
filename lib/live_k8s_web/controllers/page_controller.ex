defmodule LiveK8sWeb.PageController do
  use LiveK8sWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
