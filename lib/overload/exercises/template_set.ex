defmodule Overload.TemplateSet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "template_sets" do
    field :rep_range_min, :integer
    field :rep_range_max, :integer
    field :rir, :integer
    field :n_times, :integer
    belongs_to :template_exercise, Overload.TemplateExercise

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(template_set, attrs) do
    template_set
    |> cast(attrs, [:rep_range_min, :rep_range_max, :rir, :n_times])
    |> validate_required([:rep_range_min, :rep_range_max, :rir, :n_times])
  end
end
