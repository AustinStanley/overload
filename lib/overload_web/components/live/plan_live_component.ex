defmodule OverloadWeb.Components.Live.PlanComponent do
  use Phoenix.LiveComponent
  use OverloadWeb, :verified_routes

  import OverloadWeb.CoreComponents

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div>
        <.link patch={~p"/app"}>
          plan
        </.link>
      </div>
      <div>
        <.button phx-click="mongo" phx-target={@myself}>
          Test Mongo
        </.button>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("mongo", _unsigned_params, socket) do
    Mongo.insert_one(:mongo, "test-collection", %{li: [%{foo: "foo", bar: "bar"}, %{foo: "foo1", bar: "bar1"}]})

    Mongo.find(:mongo, "test-collection", %{})
    |> Enum.to_list()
    |> IO.inspect()

    {:noreply, socket}
  end
end
