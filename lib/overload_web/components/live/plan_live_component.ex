defmodule OverloadWeb.Components.Live.PlanComponent do
  use Phoenix.LiveComponent
  use OverloadWeb, :verified_routes

  import OverloadWeb.Components.Hero

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= render_content(assigns) %>
    </div>
    """
  end

  @impl true
  def handle_event("plan_meso", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/app/plan?action=meso")}
  end

  @impl true
  def handle_event("create_template", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/app/plan?action=template")}
  end

  defp render_content(%{action: :plan_meso} = assigns) do
    ~H"""
    <div>
      <h2>Plan Mesocycle</h2>
      <!-- Add mesocycle planning UI here -->
    </div>
    """
  end

  defp render_content(%{action: :create_template} = assigns) do
    ~H"""
    <div>
      <h2>Create Workout Template</h2>
      <!-- Add template creation UI here -->
    </div>
    """
  end

  defp render_content(assigns) do
    ~H"""
    <div class="flex flex-col gap-4">
      <.hero class="cursor-pointer bg-gradient-to-br from-amber-100 to-white" phx-click="plan_meso" phx-target={@myself}>
        Plan Mesocycle
      </.hero>
      <.hero class="cursor-pointer bg-gradient-to-br from-teal-100 to-white" phx-click="create_template" phx-target={@myself}>
        Create Workout Template
      </.hero>
    </div>
    """
  end

end
