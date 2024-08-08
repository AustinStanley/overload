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
      <.live_component module={PlanComponent} id="plan" action={@plan_action} />
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
  def handle_params(params, _url, socket) do
    IO.inspect(params, label: "PARAMS")
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :plan, %{"action" => "plan_meso"}) do
    socket
    |> assign(:page_title, "Plan Mesocycle")
    |> assign(:plan_action, :plan_meso)
  end

  defp apply_action(socket, :plan, %{"action" => "create_template"}) do
    socket
    |> assign(:page_title, "Create Workout Template")
    |> assign(plan_action: :create_template)
  end

  defp apply_action(socket, :plan, _params) do
    socket
    |> assign(:page_title, "Plan")
    |> assign(:plan_action, :index)
  end

  defp apply_action(socket, _live_action, _params) do
    socket
    |> assign(:page_title, "App")
    |> assign(:plan_action, :index)
  end
end
