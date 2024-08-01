defmodule OverloadWeb.AppLive do
  use OverloadWeb, :live_view
  import OverloadWeb.Components.Hero

  alias OverloadWeb.Components.Live.PlanComponent

  @impl true
  def render(assigns) do
    ~H"""
    <%= case @live_action do %>
    <% :train -> %>
      <.link patch={~p"/app"}>
        train
      </.link>
    <% :plan -> %>
      <.live_component module={PlanComponent} id="plan" />
    <% _ -> %>
      <div class="flex flex-col gap-4">
        <.hero class="cursor-pointer bg-gradient-to-br from-teal-100 to-white" phx-click="train">
          Train
        </.hero>
        <.hero class="cursor-pointer bg-gradient-to-br from-amber-100 to-white" phx-click="plan">
          Plan
        </.hero>
      </div>
    <% end %>
    """
  end

  @impl true
  def handle_event("train", _unsigned_params, socket) do
    {:noreply, push_patch(socket, to: ~p"/app/train")}
  end

  @impl true
  def handle_event("plan", _unsigned_params, socket) do
    {:noreply, push_patch(socket, to: ~p"/app/plan")}
  end

  @impl true
  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end
end
