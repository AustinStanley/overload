defmodule Overload.Repo.Migrations.CreateTemplateExercises do
  use Ecto.Migration

  def change do
    create table(:template_exercises) do
      add :body_part, :string
      add :type, :string
      add :template_id, references(:templates, on_delete: :nothing)
      add :exercise_id, references(:exercises, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:template_exercises, [:template_id])
    create index(:template_exercises, [:exercise_id])
  end
end
