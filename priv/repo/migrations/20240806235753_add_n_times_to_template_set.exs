defmodule Overload.Repo.Migrations.AddNTimesToTemplateSet do
  use Ecto.Migration

  def change do
    alter table(:template_sets) do
      add :n_times, :integer, default: 1
    end
  end
end
