defmodule Overload.Repo.Migrations.InstructionsToText do
  use Ecto.Migration

  def change do
    alter table(:exercises) do
      modify :instructions, :text
    end
  end
end
