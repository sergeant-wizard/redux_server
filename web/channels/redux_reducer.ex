defmodule ReduxServer.ReduxReducer do
  require Logger
  use Phoenix.Channel

  def join("redux:", _message, socket) do
    Logger.debug "join"
    {:ok, socket}
  end
  def handle_in("increment", payload, socket) do
    count = payload["count"]
    {
      :reply,
      {:ok, %{"count" => count + 1}},
      socket
    }
  end
  def handle_in("decrement", payload, socket) do
    count = payload["count"]
    {
      :reply,
      {:ok, %{"count" => count - 1}},
      socket
    }
  end
end
