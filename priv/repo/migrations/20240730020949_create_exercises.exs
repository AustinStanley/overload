defmodule Overload.Repo.Migrations.CreateExercises do
  use Ecto.Migration

  def change do
    create table(:exercises) do
      add :name, :string
      add :force, :string
      add :level, :string
      add :mechanic, :string
      add :equipment, :string
      add :instructions, :string
      add :category, :string
      add :primary_muscles, {:array, :string}
      add :secondary_muscles, {:array, :string}

      timestamps(type: :utc_datetime)
    end
  end
end
