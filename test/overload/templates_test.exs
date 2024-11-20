defmodule Overload.TemplatesTest do
  use Overload.DataCase

  alias Overload.Templates
  alias Overload.Template
  alias Overload.TemplateExercise
  alias Overload.TemplateSet

  @valid_exercise_attrs %{
    name: "Bench Press",
    force: "push",
    level: "beginner",
    mechanic: "compound",
    equipment: "barbell",
    instructions: "Lie on bench, lower bar to chest, press up",
    category: "strength",
    primary_muscles: [:chest, :shoulders, :triceps],
    secondary_muscles: [:traps, :forearms]
  }

  @valid_template_exercise_attrs %{
    type: "strength",
    body_part: "chest",
    exercise_id: nil,
    template_id: nil,
    sets: []
  }

  @invalid_template_exercise_attrs %{type: nil, body_part: nil}

  @valid_template_set_attrs %{
    rep_range_min: 8,
    rep_range_max: 12,
    rir: 2,
    n_times: 3
  }

  @invalid_template_set_attrs %{rep_range_min: nil, rep_range_max: nil}

  @valid_template_attrs %{name: "My Workout Template"}
  @invalid_template_attrs %{name: nil}

  describe "templates" do
    test "get_all/0 returns all templates" do
      template = template_fixture()
      assert Templates.get_all_templates() == [template]
    end

    test "insert_template/1 with valid data creates a template" do
      assert {:ok, %Template{} = template} = Templates.insert_template(@valid_template_attrs)
      assert template.name == "My Workout Template"
    end

    test "insert_template/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Templates.insert_template(@invalid_template_attrs)
    end
  end

  describe "template exercises" do
    test "get_all_template_exercises/0 returns all template exercises" do
      {:ok, template_exercise} = template_exercise_fixture()
      assert Templates.get_all_template_exercises() |> Enum.map(&Map.drop(&1, [:sets])) == [template_exercise |> Map.drop([:sets])]
    end

    test "create_template_exercise/1 with valid data creates a template exercise" do
      exercise = exercise_fixture() |> Map.from_struct()
      template = template_fixture() |> Map.from_struct()

      attrs = Map.merge(@valid_template_exercise_attrs, %{
        exercise: exercise,
        template: template
      })

      assert {:ok, %TemplateExercise{}} = Templates.create_template_exercise(attrs)
    end
  end

  describe "template sets" do
    test "get_all_template_sets/0 returns all template sets" do
      {:ok, template_set} = template_set_fixture()
      assert Templates.get_all_template_sets() == [template_set]
    end

    test "create_template_set/1 with valid data creates a template set" do
      assert {:ok, %TemplateSet{}} = Templates.create_template_set(@valid_template_set_attrs)
    end
  end

  defp exercise_fixture(attrs \\ %{}) do
    {:ok, exercise} =
      attrs
      |> Enum.into(@valid_exercise_attrs)
      |> Overload.Exercises.create_exercise()

    exercise
  end

  defp template_fixture(attrs \\ %{}) do
    user = Overload.AccountsFixtures.user_fixture() |> Map.from_struct()

    {:ok, template} =
      attrs
      |> Enum.into(@valid_template_attrs)
      |> Map.put(:user, user)
      |> Templates.insert_template()

    template
  end

  defp template_exercise_fixture(attrs \\ %{}) do
    template = template_fixture() |> Map.from_struct()
    exercise = exercise_fixture() |> Map.from_struct()

    attrs
    |> Enum.into(@valid_template_exercise_attrs)
    |> Map.put(:template, template)
    |> Map.put(:exercise, exercise)
    |> Templates.create_template_exercise()
  end

  defp template_set_fixture(attrs \\ %{}) do
    template_exercise = template_exercise_fixture()
    attrs
    |> Enum.into(@valid_template_set_attrs)
    |> Map.put(:template_exercise, template_exercise)
    |> Templates.create_template_set()
  end
end
