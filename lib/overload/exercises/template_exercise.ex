defmodule Overload.TemplateExercise do
  use Ecto.Schema
  import Ecto.Changeset

  alias Overload.Exercise
  alias Overload.Template
  alias Overload.TemplateSet

  schema "template_exercises" do
    field :type, :string
    field :body_part, :string
    belongs_to :exercise, Exercise
    has_many :sets, TemplateSet
    belongs_to :template, Template

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(template_exercise, attrs) do
    template_exercise
    |> cast(attrs, [:body_part, :type])
    |> cast_assoc(:exercise)
    |> cast_assoc(:template)
    |> validate_required([:body_part, :type, :exercise, :template])
  end
end
