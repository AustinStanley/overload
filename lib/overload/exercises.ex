defmodule Overload.Exercises do
  import Ecto.Query, warn: false
  alias Overload.Repo
  alias Overload.Exercise

  def seeded?() do
    Repo.exists?(Exercise)
  end

  def get_all() do
    Repo.all(Exercise)
  end

  def get_by_force_mechanic_bodypart(force, mechanic, body_part) do
    query =
      from e in Exercise,
        where:
          e.force == ^force and e.mechanic == ^mechanic and
            (^body_part in e.primary_muscles or ^body_part in e.secondary_muscles),
        select: e

    Repo.all(query)
  end

  def get_by_mechanic_bodypart(mechanic, body_part) do
    query =
      from e in Exercise,
        where:
          e.mechanic == ^mechanic and
            (^body_part in e.primary_muscles or ^body_part in e.secondary_muscles),
        select: e

    Repo.all(query)
  end

  def get_all_equipment() do
    query =
      from e in Exercise,
        where: not is_nil(e.equipment),
        select: e.equipment,
        group_by: e.equipment

    Repo.all(query)
  end

  # Generate functions for each body part and mechanic

  @body_parts Overload.Exercise.get_muscle_groups() |> Enum.map(&to_string/1)
  @mechanics ~w(compound isolation)

  for body_part <- @body_parts, mechanic <- @mechanics do
    def unquote(:"get_#{mechanic}_#{body_part}")() do
      get_by_mechanic_bodypart(unquote(mechanic), unquote(body_part))
    end
  end

  def create_exercise(attrs \\ %{}) do
    %Exercise{}
    |> Exercise.changeset(attrs)
    |> Repo.insert()
  end
end
