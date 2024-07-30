defmodule OverloadWeb.AppLive do
  use OverloadWeb, :live_view
  import OverloadWeb.Components.Hero

  @impl true
  def render(assigns) do
    ~H"""
    <.hero class="cursor-pointer bg-gradient-to-br from-teal-100 to-white" phx_click="train">
      Train
    </.hero>
    <.hero class="cursor-pointer bg-gradient-to-br from-amber-100 to-white" phx_click="plan">
      Plan
    </.hero>
    """
  end

  @impl true
  def handle_event("train", _unsigned_params, socket) do
    IO.inspect("train clicked")
    {:noreply, socket}
  end

  @impl true
  def handle_event("plan", _unsigned_params, socket) do
    IO.inspect("plan clicked")
    {:noreply, socket}
  end
end
