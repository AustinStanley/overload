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

File.read!("../../free-exercise-db/dist/exercises.json")
|> Jason.decode!()
|> Enum.map(fn e ->
  %Exercise{
    force: e.force,
    name: e.name,
    instructions: Enum.join(e.instructions, "\n"),
    level: e.level,
    category: e.category,
    mechanic: e.mechanic,
    equipment: e.equipment,
    primary_muscles: e.primaryMuscles,
    secondary_muscles: e.secondaryMuscles
  }
  |> Repo.insert!()
end)
