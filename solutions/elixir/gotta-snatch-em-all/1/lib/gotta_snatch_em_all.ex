defmodule GottaSnatchEmAll do
  @type card :: String.t()
  @type collection :: MapSet.t(card())

  @spec new_collection(card()) :: collection()
  def new_collection(card) do
    MapSet.new([card])
  end

  @spec add_card(card(), collection()) :: {boolean(), collection()}
  def add_card(card, collection) do
    duplicate? = MapSet.member?(collection, card)
    coll = MapSet.put(collection, card)
    {duplicate?, coll}
  end

  @spec trade_card(card(), card(), collection()) :: {boolean(), collection()}
  def trade_card(your_card, their_card, collection) do
    with got_my_card? = MapSet.member?(collection, your_card),
         {duplicate, add_coll} = add_card(their_card, collection),
         new_coll = MapSet.delete(add_coll, your_card)
    do
      {!duplicate and got_my_card?, new_coll}
    end
  end

  @spec remove_duplicates([card()]) :: [card()]
  def remove_duplicates(cards) do
    cards
    |> MapSet.new()
    |> MapSet.to_list()
    |> Enum.sort()
  end

  @spec extra_cards(collection(), collection()) :: non_neg_integer()
  def extra_cards(your_collection, their_collection) do
    your_collection
    |> MapSet.difference(their_collection)
    |> Enum.count()
  end

  @spec boring_cards([collection()]) :: [card()]
  def boring_cards(collections) when is_list(collections) do
    collections
    |> Enum.reduce(get_all_cards(collections), &MapSet.intersection/2)
    |> MapSet.to_list()
    |> Enum.sort()
  end

  defp get_all_cards([]), do: MapSet.new()
  defp get_all_cards(collections) do
    collections
    |> Enum.reduce(MapSet.new(), &MapSet.union/2)
  end

  @spec total_cards([collection()]) :: non_neg_integer()
  def total_cards(collections) do
    collections
    |> get_all_cards()
    |> Enum.count()
  end

  @spec split_shiny_cards(collection()) :: {[card()], [card()]}
  def split_shiny_cards(collection) do
    collection
    |> Enum.split_with(&(Regex.match?(~r/^Shiny /, &1)))
  end
end
