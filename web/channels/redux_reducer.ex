defmodule ReduxServer.ReduxReducer do
  use Phoenix.Channel

  intercept ["update"]

  def update_count("increment") do
    fn(count) -> count + 1 end
  end
  def update_count("decrement") do
    fn(count) -> count - 1 end
  end
  def reducer(action, state, socket) do
    cond do
      Enum.member?(~w(increment decrement), action) ->
        Map.update(state, "count", 0, update_count(action))
      action == "async" ->
        state
      true ->
        state
    end
  end
  def handle_action(action, socket, state) do
    cond do
      action == "async" ->
        spawn fn ->
          :timer.sleep(1000)
          broadcast! socket, "update", %{"count" => 14, "user" => state["user"]}
        end
        true ->
    end
  end
  def join("redux:", _message, socket) do
    {:ok, socket}
  end
  def handle_in(action, payload, socket) do
    socket = assign(socket, "user", payload["user"]);
    handle_action(action, socket, payload)
    {
      :reply,
      {:ok, reducer(action, payload, socket)},
      socket
    }
  end
  def handle_out("update", msg, socket) do
    if msg["user"] == socket.assigns["user"] do
      push socket, "update", msg
    end
    {:noreply, socket}
  end
end
