defmodule GeoPartition.Graph do
  @moduledoc """
  Graph representation of a polygon
  """

  alias GeoPartition.{Geometry, Util}

  defstruct [
    vertices: [],
    edges: []
  ]

  def from_polygon(shape = %{__struct__: Geo.Polygon, coordinates: coords = [outer|holes]}) do
    {v, e} = add_ring_to_graph({[], []}, outer, :outer)
    {vertices, edges} = List.foldl(holes, {v, e}, &add_ring_to_graph(&2, &1, :inner))
                        |> add_coverage(coords)
                        |> add_intersections
    %GeoPartition.Graph{
      vertices: vertices,
      edges: edges
    };
  end

  def add_coverage({v, e}, coords = [outer|holes]) do
    vertices = add_coverage(v, coords)
    edges = add_coverage(e, coords)
    {vertices, edges}
  end

  def add_coverage(e = [%MapSet{}|_], coords) do
    e
    |> Enum.map(&MapSet.to_list(&1))
    |> List.flatten
    |> add_coverage(coords)
    |> Enum.chunk_every(2, 2, :discard)
    |> Enum.map(&MapSet.new(&1))
  end

  def add_coverage(v, coords = [outer|holes]) when is_list(v) do
    Enum.map(v, fn(x = %{properties: %{ring: ring_type}}) ->
      if ring_type == :inner do
        props = Map.put(x.properties, :covered, covered?(outer, x))
        Map.put(x, :properties, props)
      else
        props = Map.put(x.properties, :covered, covered?(holes, x))
        Map.put(x, :properties, props)
      end
    end)
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

    offset = length(e)
    edges = vertices
            |> Enum.chunk_every(2, 1, :discard)
            |> Enum.map(&MapSet.new(&1))
    {v ++ Enum.slice(vertices, 0..-2), e ++ edges}
  end

  defp add_intersections({v, e}) do
    for x <- e, y <- e do
      case Geometry.intersection(edge_to_seg(x), edge_to_seg(y)) do
        {:intersects, point} -> point
        _ -> nil
      end
    end
    |> Enum.reject(&is_nil(&1))
    |> Enum.uniq
    |> List.foldr({v, e}, &subdivide(&2, &1))
  end

  def subdivide({vertices, edges}, point) do
    props = Map.put(point.properties, :ring, :intersection)
            |> Map.put(:covered, false)
    vertices = vertices ++ [c = Map.put(point, :properties, props)]
    intersected_edges = Enum.filter(edges, &Geometry.soft_contains?(edge_to_seg(&1), c))
    edges = new_edges(intersected_edges, c)
            |> Kernel.++(edges)
            |> Enum.reject(&(Enum.member?(intersected_edges, &1)))
    {vertices, edges}
  end

  defp new_edges(intersected_edges, point) do
    inters = Enum.map(intersected_edges, &MapSet.to_list(&1))
             |> List.flatten
             |> Enum.map(&MapSet.new([&1, point]))
  end

  defp points_to_seg([a, b]) do
    %Geo.LineString{
      coordinates: [
        a.coordinates,
        b.coordinates
      ]
    }
  end

  defp edge_to_seg(e) do
    e |> MapSet.to_list |> points_to_seg
  end

  def dehole({v, e}) do
    inters = Enum.filter(v, &(&1.properties.ring == :intersection))
    for x <- inters, y <- inters do
      if x == y do
        nil
      else
        [x, y]
      end
    end
    |> Enum.reject(&is_nil(&1))
    |> Enum.uniq_by(&MapSet.new(&1))
  end

  defp get_next_vertex(next, last) do
    if next == nil do
      nil
    else
      MapSet.difference(next, MapSet.new([last]))
      |> Enum.to_list
      |> hd
    end
  end

  def find_path_by({v, e}, target, fun, list) do
    last = List.last(list)
    next = Enum.find(e, &(
      MapSet.member?(&1, last)
      && MapSet.disjoint?(&1, MapSet.new(Enum.slice(list, 0..-2)))
      && fun.(&1)))
    next_vertex = get_next_vertex(next, last)
    cond do
      list == [] -> nil
      next == nil && length(list) == 1 -> nil # we're done, no path
      next == nil || Enum.member?(list, next_vertex) ->
        next_graph = delete_vertex({v, e}, last)
        next_list = Enum.slice(list, 0..-2)
        find_path_by(next_graph, target, fun, next_list)
      next_vertex == target ->
        list
        |> Kernel.++([next_vertex])
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(&MapSet.new(&1))
      true -> find_path_by({v, e}, target, fun, list ++ [next_vertex])
    end
  end

  defp delete_vertex({v,e}, vertex) do
    edges = e
    |> Enum.reject(&MapSet.member?(&1, vertex))
    vertices = Enum.reject(v, &(&1 == vertex))
    {vertices, edges}
  end

end
