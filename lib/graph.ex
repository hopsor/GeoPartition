defmodule GeoPartition.Graph do
  @moduledoc """
  Graph representation of a polygon
  """

  alias GeoPartition.Util

  defstruct [
    vertices: [],
    edges: []
  ]

  def from_polygon(shape = %{__struct__: Geo.Polygon, coordinates: coords = [outer|holes]}) do
    {v, e} = add_ring_to_graph({[], []}, outer, :outer)
    {vertices, edges}  = List.foldl(holes, {v, e}, &add_ring_to_graph(&2, &1, :inner))
                         |> add_coverage(coords)
    %GeoPartition.Graph{
      vertices: vertices,
      edges: edges
    };
  end

  def add_coverage({v, e}, coords = [outer|holes]) do
    vertices = Enum.map(v, fn(x = %{properties: %{ring: ring_type}}) ->
      if ring_type == :inner do
        props = Map.put(x.properties, :covered, covered?(outer, x))
        Map.put(x, :properties, props)
      else
        props = Map.put(x.properties, :covered, covered?(holes, x))
        Map.put(x, :properties, props)
      end
    end)
    {vertices, e}
  end

  defp covered?(rings = [[_|_]], point = %{__struct__: Geo.Point}) do
    List.foldl(rings, false, &(covered?(&1, point) || &2))
  end

  defp covered?(ring = [{a, b}|_], point = %{__struct__: Geo.Point}) do
    Topo.contains?(
      %Geo.Polygon{ coordinates: [ring] },
      point
    )
  end

  defp covered?([], _), do: false

  defp add_ring_to_graph(intial = {v, e}, ring, ring_type) do
    vertices = Enum.map(ring, fn({lng, lat}) ->
      %Geo.Point{
        coordinates: {lng, lat},
        properties: %{
          ring: ring_type,
          covered: false,
        }
      }
    end)
    |> Enum.slice(0..-2)

    offset = length(e)
    edges = Enum.to_list(offset..length(vertices) + offset - 1)
    |> List.foldr([], &(&2 ++ [[&1]]))
    |> Enum.reverse
    |> Util.rotate_list

    {v ++ vertices, e ++ edges}
  end
end
