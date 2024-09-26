defmodule OverloadWeb.Components.Live.PlanComponent do
  use Phoenix.LiveComponent
  use OverloadWeb, :verified_routes

  import OverloadWeb.Components.Hero
  import OverloadWeb.CoreComponents, except: [button: 1]

  import SaladUI.{Select, Button, Card, Badge, ScrollArea, Separator}

  alias Overload.Exercise
  alias Overload.Exercises
  alias Overload.Template

  @impl true
  def mount(socket) do
    template_form = Template.changeset(%Template{}, %{}) |> to_form()
    exercise_form = Exercise.changeset(%Exercise{}, %{}) |> to_form()
    exercises = Exercises.get_all()

    {:ok,
     socket
     |> assign(template_form: template_form)
     |> assign(exercise_form: exercise_form)
     |> assign(template_exercises: [])
     |> assign(all_exercises: exercises)
     |> assign(filtered_exercises: exercises)
     |> assign(filters: %{name: "", body_part: "all", equipment: "all"})
     |> assign(show_exercise_modal: false)}
  end

  defp apply_filters(exercises, filters) do
    exercises
    |> Enum.filter(fn exercise ->
      String.contains?(String.downcase(exercise.name), String.downcase(filters.name)) and
        (filters.body_part == "all" or
           String.to_atom(filters.body_part) in exercise.primary_muscles) and
        (filters.equipment == "all" or filters.equipment == exercise.equipment)
    end)
  end

  @impl true
  def handle_event("plan_meso", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/app/plan?action=plan_meso")}
  end

  @impl true
  def handle_event("create_template", _, socket) do
    {:noreply,
     socket
     |> push_patch(to: ~p"/app/plan?action=create_template")}
  end

  @impl true
  def handle_event(
        "filter_exercises",
        %{"body_part" => body_part},
        %{assigns: %{all_exercises: all_exercises}} = socket
      ) do
    filters = %{socket.assigns.filters | body_part: body_part}
    res = apply_filters(all_exercises, filters)
    {:noreply, socket |> assign(filtered_exercises: res) |> assign(filters: filters)}
  end

  @impl true
  def handle_event(
        "filter_exercises",
        %{"equipment" => equipment},
        %{assigns: %{all_exercises: all_exercises}} = socket
      ) do
    filters = %{socket.assigns.filters | equipment: equipment}
    res = apply_filters(all_exercises, filters)
    {:noreply, socket |> assign(filtered_exercises: res) |> assign(filters: filters)}
  end

  @impl true
  def handle_event(
        "filter_exercises",
        %{"name" => name},
        %{assigns: %{all_exercises: all_exercises}} = socket
      ) do
    filters = %{socket.assigns.filters | name: name}
    res = apply_filters(all_exercises, filters)
    {:noreply, socket |> assign(filtered_exercises: res) |> assign(filters: filters)}
  end

  @impl true
  def handle_event("clear_filter", %{"filter" => filter}, socket) do
    key =
      Map.to_list(socket.assigns.filters) |> Enum.find(fn {_, v} -> v == filter end) |> elem(0)

    filters = Map.replace!(socket.assigns.filters, key, "all")
    res = apply_filters(socket.assigns.all_exercises, filters)
    {:noreply, socket |> assign(filtered_exercises: res) |> assign(filters: filters)}
  end

  @impl true
  def handle_event("select_exercise", %{"exercise" => exercise}, socket) do
    {:noreply,
     socket
     |> assign(
       selected_exercise:
         socket.assigns.filtered_exercises
         |> Enum.find(fn x -> x.id == String.to_integer(exercise) end)
     )}
  end

  @impl true
  def handle_event("save_exercise", _params, socket) do
    IO.inspect(socket.assigns.selected_exercise)
    updated_exercises = [socket.assigns.selected_exercise | socket.assigns.template_exercises]
    updated_form = Map.put(socket.assigns.template_form, :exercises, updated_exercises)

    {:noreply,
     socket
     |> assign(template_exercises: updated_exercises, template_form: updated_form)
     |> assign(show_exercise_modal: false)}
  end

  @impl true
  def handle_event("remove_exercise", %{"index" => index}, socket) do
    updated_exercises = List.delete(socket.assigns.template_exercises, Enum.at(socket.assigns.template_exercises, String.to_integer(index)))
    updated_form = Map.put(socket.assigns.template_form, :exercises, updated_exercises)
    {:noreply, socket |> assign(template_exercises: updated_exercises, template_form: updated_form)}
  end

  @impl true
  def handle_event("toggle_exercise_modal", _params, socket) do
    {:noreply, socket |> assign(show_exercise_modal: !socket.assigns.show_exercise_modal)}
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
    <div class="flex flex-col gap-4 items-center">
      <h2 class="text-2xl font-bold">Create Workout Template</h2>
      <div>
        <.form for={@template_form} phx-change="validate" phx-submit="save" as={:template}>
          <.input
            type="text"
            name="name"
            placeholder="Template Name"
            value={@template_form[:name].value}
          />

          <div id="exercises">
            <%= for {exercise, index} <- Enum.with_index(@template_exercises) do %>
              <div class="exercise-container">
                <div class="flex gap-2 items-center">
                  <div class="cursor-pointer" phx-click="remove_exercise" phx-value-index={index} phx-target={@myself}>
                    <.icon name="hero-x-mark" class="w-4 h-4" />
                  </div>
                  <%= exercise.name %>
                </div>
              </div>
            <% end %>
          </div>
          <div class="flex justify-center gap-4 mt-4">
            <.button type="button" phx-click="toggle_exercise_modal" phx-target={@myself}>
              Add Exercise
            </.button>
            <.button type="submit" disabled>Create Template</.button>
          </div>
        </.form>
      </div>
    </div>
    """
  end

  defp render_content(assigns) do
    ~H"""
    <div class="flex flex-col gap-4">
      <.hero
        class="cursor-pointer bg-gradient-to-br from-amber-100 to-white"
        phx-click="plan_meso"
        phx-target={@myself}
      >
        Plan Mesocycle
      </.hero>
      <.hero
        class="cursor-pointer bg-gradient-to-br from-teal-100 to-white"
        phx-click="create_template"
        phx-target={@myself}
      >
        Create Workout Template
      </.hero>
    </div>
    """
  end
end
