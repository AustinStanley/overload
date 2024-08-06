defmodule Overload.TemplateExercise do
  use Ecto.Schema
  import Ecto.Changeset

  schema "template_exercises" do
    field :type, :string
    field :body_part, :string
    field :exercise_id, :id
    has_many :sets, TemplateSet
    belongs_to :template_id, Template

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(template_exercise, attrs) do
    template_exercise
    |> cast(attrs, [:body_part, :type])
    |> validate_required([:body_part, :type])
  end
end
