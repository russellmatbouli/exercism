defmodule HighScore do
  def new() do
    %{}
  end

  def add_player(scores, name) do
    scores
    |> Map.put(name, 0)
  end
  def add_player(scores, name, score) do
    scores
    |> Map.put(name, score)
  end

  def remove_player(scores, name) do
    scores
    |> Map.delete(name)
  end

  def reset_score(scores, name) do
    add_player(scores, name)
  end

  def update_score(scores, name, score) do
    scores
    |> Map.update(name, score, &(&1 + score))
  end

  def get_players(scores) do
    Map.keys(scores)
  end
end
