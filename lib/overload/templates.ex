defmodule Overload.Templates do
  alias Overload.Repo
  alias Overload.Template
  alias Overload.TemplateExercise
  alias Overload.TemplateSet

  def get_all_templates() do
    Repo.all(Template)
  end

  def insert_template(attrs) do
    %Template{}
    |> Template.changeset(attrs)
    |> Repo.insert()
  end

  def get_template!(id), do: Repo.get!(Template, id)

  def update_template(%Template{} = template, attrs) do
    template
    |> Template.changeset(attrs)
    |> Repo.update()
  end

  def delete_template(%Template{} = template) do
    Repo.delete(template)
  end

  def get_all_template_exercises() do
    TemplateExercise
    |> Repo.all()
    |> Repo.preload([:exercise, :template, :sets])
  end

  def get_template_exercise!(id), do: Repo.get!(TemplateExercise, id)

  def create_template_exercise(attrs \\ %{}) do
    %TemplateExercise{}
    |> TemplateExercise.changeset(attrs)
    |> Repo.insert()
  end

  def update_template_exercise(%TemplateExercise{} = template_exercise, attrs) do
    template_exercise
    |> TemplateExercise.changeset(attrs)
    |> Repo.update()
  end

  def delete_template_exercise(%TemplateExercise{} = template_exercise) do
    Repo.delete(template_exercise)
  end

  def get_all_template_sets() do
    Repo.all(TemplateSet)
  end

  def get_template_set!(id), do: Repo.get!(TemplateSet, id)

  def create_template_set(attrs \\ %{}) do
    %TemplateSet{}
    |> TemplateSet.changeset(attrs)
    |> Repo.insert()
  end

  def update_template_set(%TemplateSet{} = template_set, attrs) do
    template_set
    |> TemplateSet.changeset(attrs)
    |> Repo.update()
  end

  def delete_template_set(%TemplateSet{} = template_set) do
    Repo.delete(template_set)
  end
end
