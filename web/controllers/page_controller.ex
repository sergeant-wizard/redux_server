defmodule ReduxServer.PageController do
  use ReduxServer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
