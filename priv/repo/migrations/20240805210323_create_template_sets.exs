defmodule Overload.Repo.Migrations.CreateTemplateSets do
  use Ecto.Migration

  def change do
    create table(:template_sets) do
      add :rep_range_min, :integer
      add :rep_range_max, :integer
      add :rir, :integer
      add :template_exercise_id, references(:template_exercises, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:template_sets, [:template_exercise_id])
  end
end
