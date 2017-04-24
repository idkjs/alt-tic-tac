defmodule AltTicTac1.Web.PageController do
  use AltTicTac1.Web, :controller

  def index(conn, _params) do
    render conn, "index_lol.html"
  end
end
