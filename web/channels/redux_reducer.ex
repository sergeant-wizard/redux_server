defmodule ReduxServer.ReduxReducer do
  use Phoenix.Channel

  def update_count("increment") do
    fn(count) -> count + 1 end
  end
  def update_count("decrement") do
    fn(count) -> count - 1 end
  end
  def reducer(type, state) do
    Map.update(state, "count", 0, update_count(type))
  end
  def join("redux:", _message, socket) do
    {:ok, socket}
  end
  def handle_in(str, payload, socket) do
    {
      :reply,
      {:ok, reducer(str, payload)},
      socket
    }
  end
end
