defmodule OverloadWeb.Components.Live.PlanComponent do
  use Phoenix.LiveComponent
  use OverloadWeb, :verified_routes

  import OverloadWeb.Components.Hero
  import OverloadWeb.CoreComponents, except: [button: 1]

  import SaladUI.{Select, Button, Card, Badge, ScrollArea, Separator}

  alias Overload.Template
  alias Overload.Exercise
  alias Overload.Exercises

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= render_content(assigns) %>

      <.modal id="add-exercise-modal">
        <.form
          for={@exercise_form}
          phx-change="filter_exercises"
          phx-submit="save"
          phx-target={@myself}
          as={:exercise}
        >
          <.card>
            <.card_header>
              <.card_title>
                Filters
              </.card_title>
            </.card_header>
            <.card_content>
              <.input type="text" name="name" placeholder="Name" value={@exercise_form[:name].value} />
              <div class="flex gap-4">
                <.select
                  :let={select}
                  id="body-part-select"
                  name="body_part"
                  target="my-select"
                  placeholder="Muscle Group"
                  class="mt-4"
                >
                  <.select_trigger instance={select} target="my-select" />
                  <.select_content instance={select}>
                    <.select_group>
                      <%= for body_part <- [:all | Exercise.get_muscle_groups()] do %>
                        <.select_item
                          instance={select}
                          value={body_part}
                          label={body_part |> Atom.to_string() |> String.capitalize()}
                        >
                        </.select_item>
                      <% end %>
                    </.select_group>
                  </.select_content>
                </.select>

                <.select
                  :let={select}
                  id="equipment-select"
                  name="equipment"
                  target="equipment-select"
                  placeholder="Equipment"
                  class="mt-4"
                >
                  <.select_trigger instance={select} target="equipment-select" />
                  <.select_content instance={select}>
                    <.select_group>
                      <%= for equipment <- ["all" | Exercises.get_all_equipment()] do %>
                        <.select_item
                          instance={select}
                          value={equipment}
                          label={String.capitalize(equipment)}
                        >
                        </.select_item>
                      <% end %>
                    </.select_group>
                  </.select_content>
                </.select>
              </div>
            </.card_content>
            <.card_footer class="flex justify-start pt-2 gap-2">
              <%= for filter <- @filters |> Map.drop([:name]) |> Map.values() |> Enum.filter(&(&1 != "all")) do %>
                <.badge
                  variant="outline"
                  class="text-sm gap-1 cursor-pointer"
                  phx-click="clear_filter"
                  phx-value-filter={filter}
                  phx-target={@myself}
                >
                  <.icon name="hero-x-mark-mini" class="w-3 h-3" />
                  <%= filter %>
                </.badge>
              <% end %>
            </.card_footer>
          </.card>

          <.scroll_area class="h-48 rounded-md border my-4 p-4">
            <%= for %Exercise{name: name} <- @filtered_exercises do %>
              <div>
                <%= name %>
              </div>
              <.separator class="my-2" />
            <% end %>
          </.scroll_area>
          <div class="flex justify-between">
            <.button type="submit">Add Exercise</.button>
            <.button type="">Create Exercise</.button>
          </div>
        </.form>
      </.modal>
    </div>
    """
  end

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
     |> assign(filters: %{name: "", body_part: "all", equipment: "all"})}
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
                <.input
                  type="text"
                  name={"template[exercises][#{index}][body_part]"}
                  placeholder="Body Part"
                  value={exercise.body_part}
                />
                <.input
                  type="text"
                  name={"template[exercises][#{index}][type]"}
                  placeholder="Exercise Type"
                  value={exercise.type}
                />

                <div class="sets-container">
                  <%= for {set, set_index} <- Enum.with_index(exercise.sets || []) do %>
                    <div class="set-inputs">
                      <.input
                        type="number"
                        name={"template[exercises][#{index}][sets][#{set_index}][rep_range_min]"}
                        placeholder="Min Reps"
                        value={set.rep_range_min}
                      />
                      <.input
                        type="number"
                        name={"template[exercises][#{index}][sets][#{set_index}][rep_range_max]"}
                        placeholder="Max Reps"
                        value={set.rep_range_max}
                      />
                      <.input
                        type="number"
                        name={"template[exercises][#{index}][sets][#{set_index}][rir]"}
                        placeholder="RIR"
                        value={set.rir}
                      />
                      <.input
                        type="number"
                        name={"template[exercises][#{index}][sets][#{set_index}][n_times]"}
                        placeholder="Times"
                        value={set.n_times}
                      />
                    </div>
                  <% end %>
                  <.button type="button" phx-click="add_set" phx-value-exercise={index}>
                    Add Set
                  </.button>
                </div>

                <.button type="button" phx-click="remove_exercise" phx-value-index={index}>
                  Remove Exercise
                </.button>
              </div>
            <% end %>
          </div>
          <div class="flex justify-center gap-4 mt-4">
            <.button type="button" phx-click={show_modal("add-exercise-modal")} phx-target={@myself}>
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
