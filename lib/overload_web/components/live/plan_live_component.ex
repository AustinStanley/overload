defmodule OverloadWeb.Components.Live.PlanComponent do
  use Phoenix.LiveComponent
  use OverloadWeb, :verified_routes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.link patch={~p"/app"}>
        plan
      </.link>
    </div>
    """
  end
end
