defmodule ReduxServer.RoomChannel do
  require Logger
  use Phoenix.Channel

  def join("rooms:lobby", _message, socket) do
    Logger.debug "join"
    {:ok, socket}
  end
  def join("rooms:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
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
