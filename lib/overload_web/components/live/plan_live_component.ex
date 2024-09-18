defmodule OverloadWeb.Components.Live.PlanComponent do
  use Phoenix.LiveComponent
  use OverloadWeb, :verified_routes

  import OverloadWeb.Components.Hero
  import OverloadWeb.CoreComponents, except: [button: 1]
  import SaladUI.Select
  import SaladUI.Button
  alias Overload.Template
  alias Overload.Exercise
  alias Overload.Exercises

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= render_content(assigns) %>

      <.modal id="add-exercise-modal">
        <.form for={@exercise_form} phx-change="filter_exercises" phx-submit="save" phx-target={@myself} as={:exercise}>
          <.input type="text" name="name" placeholder="Filter" value={@exercise_form[:name].value} />
          <.select :let={select} id="body-part-select" name="body_part" target="my-select" placeholder="Body Part" class="mt-4">
            <.select_trigger instance={select} target="my-select"/>
            <.select_content instance={select}>
              <.select_group>

              <%= for body_part <- Exercise.get_muscle_groups() do %>
                  <.select_item instance={select} value={body_part} label={body_part |> Atom.to_string() |> String.capitalize()} ></.select_item>
                <% end %>
              </.select_group>
            </.select_content>
          </.select>
          <div class="flex flex-col gap-4 h-48 overflow-scroll my-4 px-4 border">
            <%= for %Exercise{name: name} <- @filtered_exercises do %>
              <div>
                <%= name %>
              </div>
            <% end %>
          </div>
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

    {:ok, socket
     |> assign(template_form: template_form)
     |> assign(exercise_form: exercise_form)
     |> assign(template_exercises: [])
     |> assign(all_exercises: exercises)
     |> assign(filtered_exercises: exercises)
     |> assign(filters: %{name: "", body_part: :all})}
  end

  defp apply_filters(exercises, filters) do
    exercises
    |> Enum.filter(fn exercise ->
      String.contains?(String.downcase(exercise.name), String.downcase(filters.name))
      and (filters.body_part == :all or String.to_atom(filters.body_part) in exercise.primary_muscles)
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
  def handle_event("filter_exercises", %{"body_part" => body_part}, %{assigns: %{all_exercises: all_exercises}} = socket) do
    filters = %{socket.assigns.filters | body_part: body_part}
    res = apply_filters(all_exercises, filters)
    {:noreply, socket |> assign(filtered_exercises: res) |> assign(filters: filters)}
  end

  @impl true
  def handle_event("filter_exercises", %{"name" => name}, %{assigns: %{all_exercises: all_exercises}} = socket) do
    filters = %{socket.assigns.filters | name: name}
    res = apply_filters(all_exercises, filters)
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
          <.input type="text" name="name" placeholder="Template Name" value={@template_form[:name].value} />

          <div id="exercises">
            <%= for {exercise, index} <- Enum.with_index(@template_exercises) do %>
              <div class="exercise-container">
                <.input type="text" name={"template[exercises][#{index}][body_part]"} placeholder="Body Part" value={exercise.body_part} />
                <.input type="text" name={"template[exercises][#{index}][type]"} placeholder="Exercise Type" value={exercise.type} />

                <div class="sets-container">
                  <%= for {set, set_index} <- Enum.with_index(exercise.sets || []) do %>
                    <div class="set-inputs">
                      <.input type="number" name={"template[exercises][#{index}][sets][#{set_index}][rep_range_min]"} placeholder="Min Reps" value={set.rep_range_min} />
                      <.input type="number" name={"template[exercises][#{index}][sets][#{set_index}][rep_range_max]"} placeholder="Max Reps" value={set.rep_range_max} />
                      <.input type="number" name={"template[exercises][#{index}][sets][#{set_index}][rir]"} placeholder="RIR" value={set.rir} />
                      <.input type="number" name={"template[exercises][#{index}][sets][#{set_index}][n_times]"} placeholder="Times" value={set.n_times} />
                    </div>
                  <% end %>
                  <.button type="button" phx-click="add_set" phx-value-exercise={index}>Add Set</.button>
                </div>

                <.button type="button" phx-click="remove_exercise" phx-value-index={index}>Remove Exercise</.button>
              </div>
            <% end %>
          </div>
          <div class="flex justify-center gap-4 mt-4">
            <.button type="button" phx-click={show_modal("add-exercise-modal")} phx-target={@myself}>Add Exercise</.button>
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
