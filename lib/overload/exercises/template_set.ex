defmodule Overload.TemplateSet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "template_sets" do
    field :rep_range_min, :integer
    field :rep_range_max, :integer
    field :rir, :integer
    belongs_to :template_exercise_id, TemplateExercise

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(template_set, attrs) do
    template_set
    |> cast(attrs, [:rep_range_min, :rep_range_max, :rir])
    |> validate_required([:rep_range_min, :rep_range_max, :rir])
  end
end
