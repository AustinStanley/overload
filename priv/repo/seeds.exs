# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Overload.Repo.insert!(%Overload.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Overload.{Repo, Exercise}

if not Overload.Exercises.seeded?() do
  File.read!("../../free-exercise-db/dist/exercises.json")
  |> Jason.decode!()
  |> Enum.map(fn e ->
    %Exercise{
      force: e["force"],
      name: e["name"],
      instructions: e["instructions"] |> Enum.join("\n"),
      level: e["level"],
      category: e["category"],
      mechanic: e["mechanic"],
      equipment: e["equipment"],
      primary_muscles: e["primaryMuscles"] |> Enum.map(&String.to_atom/1),
      secondary_muscles: e["secondaryMuscles"] |> Enum.map(&String.to_atom/1)
    }
    |> Repo.insert!()
  end)
end
