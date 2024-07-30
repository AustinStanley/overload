Mix.install([
  {:jason, "~> 1.2"}
])

File.read!("../../free-exercise-db/dist/exercises.json")
  |> Jason.decode!()
  |> Enum.reduce([], fn %{"primaryMuscles" => primary, "secondaryMuscles" => secondary}, acc ->
    primary ++ secondary ++ acc
  end)
  |> Enum.uniq()
  |> Enum.map(&IO.puts/1)
