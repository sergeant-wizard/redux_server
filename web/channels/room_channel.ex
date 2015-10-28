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
    Logger.debug "increment"
    action_result = true
    state = payload["state"]
    if action_result do
      {
        :reply,
        {:ok, %{"state" => state + 1}},
        socket
      }
    else
      {:reply, {:error, state}, socket}
    end
  end
end
