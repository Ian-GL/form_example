defmodule FormExampleWeb.PageController do
  use FormExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
