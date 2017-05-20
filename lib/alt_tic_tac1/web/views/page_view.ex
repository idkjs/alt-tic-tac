defmodule AltTicTac1.Web.PageView do
  use AltTicTac1.Web, :view

  def render("start.json", %{id: id}) do
    id
  end
end
