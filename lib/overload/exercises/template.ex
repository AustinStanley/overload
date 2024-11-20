defmodule Overload.Template do
  use Ecto.Schema
  import Ecto.Changeset

  alias Overload.TemplateExercise
  alias Overload.Accounts.User

  schema "templates" do
    field :name, :string
    has_many :exercises, TemplateExercise
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(template, attrs) do
    # TODO: Add user association
    template
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
