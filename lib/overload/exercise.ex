defmodule Overload.Exercise do
  use Ecto.Schema
  import Ecto.Changeset

  @muscle_groups [
    :biceps,
    :forearms,
    :quadriceps,
    :calves,
    :glutes,
    :hamstrings,
    :abdominals,
    :abductors,
    :adductors,
    :lower_back,
    :shoulders,
    :lats,
    :middle_back,
    :chest,
    :triceps,
    :traps,
    :neck
  ]

  schema "exercises" do
    field :force, :string
    field :name, :string
    field :instructions, :string
    field :level, :string
    field :category, :string
    field :mechanic, :string
    field :equipment, :string

    field :primary_muscles, {:array, Ecto.Enum}, values: @muscle_groups
    field :secondary_muscles, {:array, Ecto.Enum}, values: @muscle_groups

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(exercise, attrs) do
    exercise
    |> cast(attrs, [:name, :force, :level, :mechanic, :equipment, :instructions, :category])
    |> validate_required([:name, :force, :level, :mechanic, :equipment, :instructions, :category])
  end
end
