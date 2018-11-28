defmodule GeoPartitionTest do
  use ExUnit.Case
  doctest GeoPartition

  alias GeoPartition.Shapes

  describe "partition" do
    test "Polygon input" do
      shape = Shapes.intersecting_diamonds
      assert GeoPartition.partition(shape, 10, :multipolygon) == %Geo.MultiPolygon{
        coordinates: [
          [
            [
              {-84.16557312011717, 36.887858857884986},
              {-84.15544774212663, 36.90341222036663},
              {-84.17381286621094, 36.91641125204138},
              {-84.23904418945313, 36.875775782851},
              {-84.16557312011717, 36.887858857884986}
            ]
          ],
          [
            [
              {-84.16557312011717, 36.887858857884986},
              {-84.14282165268783, 36.894475338928224},
              {-84.11407470703125, 36.87412794266634},
              {-84.16557312011717, 36.887858857884986}
            ]
          ],
          [
            [
              {-84.23904418945313, 36.875775782851},
              {-84.16557312011717, 36.887858857884986},
              {-84.11407470703125, 36.87412794266634},
              {-84.23904418945313, 36.875775782851}
            ]
          ],
          [
            [
              {-84.11407470703125, 36.87412794266634},
              {-84.17861938476563, 36.83401954216856},
              {-84.23904418945313, 36.875775782851},
              {-84.11407470703125, 36.87412794266634}
            ]
          ]
        ],
        properties: %{},
        srid: nil
      }

      assert GeoPartition.partition(shape, 10, :multipolygon_json) == ~S({"type":"MultiPolygon","coordinates":[[[[-84.16557312011717,36.887858857884986],[-84.15544774212663,36.90341222036663],[-84.17381286621094,36.91641125204138],[-84.23904418945313,36.875775782851],[-84.16557312011717,36.887858857884986]]],[[[-84.16557312011717,36.887858857884986],[-84.14282165268783,36.894475338928224],[-84.11407470703125,36.87412794266634],[-84.16557312011717,36.887858857884986]]],[[[-84.23904418945313,36.875775782851],[-84.16557312011717,36.887858857884986],[-84.11407470703125,36.87412794266634],[-84.23904418945313,36.875775782851]]],[[[-84.11407470703125,36.87412794266634],[-84.17861938476563,36.83401954216856],[-84.23904418945313,36.875775782851],[-84.11407470703125,36.87412794266634]]]]})

      assert GeoPartition.partition(shape, 10, :feature_collection) == %{
        "features" => [
          %{
            "geometry" => %{
              "coordinates" => [
                [
                  [-84.16557312011717, 36.887858857884986],
                  [-84.15544774212663, 36.90341222036663],
                  [-84.17381286621094, 36.91641125204138],
                  [-84.23904418945313, 36.875775782851],
                  [-84.16557312011717, 36.887858857884986]
                ]
              ],
              "type" => "Polygon"
            },
            "properties" => %{},
            "type" => "Feature"
          },
          %{
            "geometry" => %{
              "coordinates" => [
                [
                  [-84.16557312011717, 36.887858857884986],
                  [-84.14282165268783, 36.894475338928224],
                  [-84.11407470703125, 36.87412794266634],
                  [-84.16557312011717, 36.887858857884986]
                ]
              ],
              "type" => "Polygon"
            },
            "properties" => %{},
            "type" => "Feature"
          },
          %{
            "geometry" => %{
              "coordinates" => [
                [
                  [-84.23904418945313, 36.875775782851],
                  [-84.16557312011717, 36.887858857884986],
                  [-84.11407470703125, 36.87412794266634],
                  [-84.23904418945313, 36.875775782851]
                ]
              ],
              "type" => "Polygon"
            },
            "properties" => %{},
            "type" => "Feature"
          },
          %{
            "geometry" => %{
              "coordinates" => [
                [
                  [-84.11407470703125, 36.87412794266634],
                  [-84.17861938476563, 36.83401954216856],
                  [-84.23904418945313, 36.875775782851],
                  [-84.11407470703125, 36.87412794266634]
                ]
              ],
              "type" => "Polygon"
            },
            "properties" => %{},
            "type" => "Feature"
          }
        ],
        "type" => "FeatureCollection"
      }

      assert GeoPartition.partition(shape, 10, :feature_collection_json) == ~S({"type":"FeatureCollection","features":[{"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[-84.16557312011717,36.887858857884986],[-84.15544774212663,36.90341222036663],[-84.17381286621094,36.91641125204138],[-84.23904418945313,36.875775782851],[-84.16557312011717,36.887858857884986]]]}},{"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[-84.16557312011717,36.887858857884986],[-84.14282165268783,36.894475338928224],[-84.11407470703125,36.87412794266634],[-84.16557312011717,36.887858857884986]]]}},{"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[-84.23904418945313,36.875775782851],[-84.16557312011717,36.887858857884986],[-84.11407470703125,36.87412794266634],[-84.23904418945313,36.875775782851]]]}},{"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[-84.11407470703125,36.87412794266634],[-84.17861938476563,36.83401954216856],[-84.23904418945313,36.875775782851],[-84.11407470703125,36.87412794266634]]]}}]})

      assert GeoPartition.partition(shape, 10, :feature_collection_multipolygon) == %{
        "features" => [
          %{
            "geometry" => %{
              "coordinates" => [
                [
                  [
                    [-84.16557312011717, 36.887858857884986],
                    [-84.15544774212663, 36.90341222036663],
                    [-84.17381286621094, 36.91641125204138],
                    [-84.23904418945313, 36.875775782851],
                    [-84.16557312011717, 36.887858857884986]
                  ]
                ]
              ],
              "type" => "MultiPolygon"
            },
            "properties" => %{},
            "type" => "Feature"
          },
          %{
            "geometry" => %{
              "coordinates" => [
                [
                  [
                    [-84.16557312011717, 36.887858857884986],
                    [-84.14282165268783, 36.894475338928224],
                    [-84.11407470703125, 36.87412794266634],
                    [-84.16557312011717, 36.887858857884986]
                  ]
                ]
              ],
              "type" => "MultiPolygon"
            },
            "properties" => %{},
            "type" => "Feature"
          },
          %{
            "geometry" => %{
              "coordinates" => [
                [
                  [
                    [-84.23904418945313, 36.875775782851],
                    [-84.16557312011717, 36.887858857884986],
                    [-84.11407470703125, 36.87412794266634],
                    [-84.23904418945313, 36.875775782851]
                  ]
                ]
              ],
              "type" => "MultiPolygon"
            },
            "properties" => %{},
            "type" => "Feature"
          },
          %{
            "geometry" => %{
              "coordinates" => [
                [
                  [
                    [-84.11407470703125, 36.87412794266634],
                    [-84.17861938476563, 36.83401954216856],
                    [-84.23904418945313, 36.875775782851],
                    [-84.11407470703125, 36.87412794266634]
                  ]
                ]
              ],
              "type" => "MultiPolygon"
            },
            "properties" => %{},
            "type" => "Feature"
          }
        ],
        "type" => "FeatureCollection"
      }

      assert GeoPartition.partition(shape, 10, :feature_collection_multipolygon_json) == ~S({"type":"FeatureCollection","features":[{"type":"Feature","properties":{},"geometry":{"type":"MultiPolygon","coordinates":[[[[-84.16557312011717,36.887858857884986],[-84.15544774212663,36.90341222036663],[-84.17381286621094,36.91641125204138],[-84.23904418945313,36.875775782851],[-84.16557312011717,36.887858857884986]]]]}},{"type":"Feature","properties":{},"geometry":{"type":"MultiPolygon","coordinates":[[[[-84.16557312011717,36.887858857884986],[-84.14282165268783,36.894475338928224],[-84.11407470703125,36.87412794266634],[-84.16557312011717,36.887858857884986]]]]}},{"type":"Feature","properties":{},"geometry":{"type":"MultiPolygon","coordinates":[[[[-84.23904418945313,36.875775782851],[-84.16557312011717,36.887858857884986],[-84.11407470703125,36.87412794266634],[-84.23904418945313,36.875775782851]]]]}},{"type":"Feature","properties":{},"geometry":{"type":"MultiPolygon","coordinates":[[[[-84.11407470703125,36.87412794266634],[-84.17861938476563,36.83401954216856],[-84.23904418945313,36.875775782851],[-84.11407470703125,36.87412794266634]]]]}}]})

      assert GeoPartition.partition(shape, 10, :list) == [
        %Geo.Polygon{
          coordinates: [
            [
              {-84.16557312011717, 36.887858857884986},
              {-84.15544774212663, 36.90341222036663},
              {-84.17381286621094, 36.91641125204138},
              {-84.23904418945313, 36.875775782851},
              {-84.16557312011717, 36.887858857884986}
            ]
          ],
          properties: %{},
          srid: nil
        },
        %Geo.Polygon{
          coordinates: [
            [
              {-84.16557312011717, 36.887858857884986},
              {-84.14282165268783, 36.894475338928224},
              {-84.11407470703125, 36.87412794266634},
              {-84.16557312011717, 36.887858857884986}
            ]
          ],
          properties: %{},
          srid: nil
        },
        %Geo.Polygon{
          coordinates: [
            [
              {-84.23904418945313, 36.875775782851},
              {-84.16557312011717, 36.887858857884986},
              {-84.11407470703125, 36.87412794266634},
              {-84.23904418945313, 36.875775782851}
            ]
          ],
          properties: %{},
          srid: nil
        },
        %Geo.Polygon{
          coordinates: [
            [
              {-84.11407470703125, 36.87412794266634},
              {-84.17861938476563, 36.83401954216856},
              {-84.23904418945313, 36.875775782851},
              {-84.11407470703125, 36.87412794266634}
            ]
          ],
          properties: %{},
          srid: nil
        }
      ]

    end

    test "Multipolygon input" do
      shape = Shapes.intersecting_diamonds
      shape_multi = %Geo.MultiPolygon{
        coordinates: [shape.coordinates]
      }
      assert GeoPartition.partition(shape_multi, 10, :multipolygon) == %Geo.MultiPolygon{
        coordinates: [
          [
            [
              {-84.16557312011717, 36.887858857884986},
              {-84.15544774212663, 36.90341222036663},
              {-84.17381286621094, 36.91641125204138},
              {-84.23904418945313, 36.875775782851},
              {-84.16557312011717, 36.887858857884986}
            ]
          ],
          [
            [
              {-84.16557312011717, 36.887858857884986},
              {-84.14282165268783, 36.894475338928224},
              {-84.11407470703125, 36.87412794266634},
              {-84.16557312011717, 36.887858857884986}
            ]
          ],
          [
            [
              {-84.23904418945313, 36.875775782851},
              {-84.16557312011717, 36.887858857884986},
              {-84.11407470703125, 36.87412794266634},
              {-84.23904418945313, 36.875775782851}
            ]
          ],
          [
            [
              {-84.11407470703125, 36.87412794266634},
              {-84.17861938476563, 36.83401954216856},
              {-84.23904418945313, 36.875775782851},
              {-84.11407470703125, 36.87412794266634}
            ]
          ]
        ],
        properties: %{},
        srid: nil
      }
    end

    test "JSON input" do
      shape = Shapes.intersecting_diamonds |> Geo.JSON.encode! |> Poison.encode!
      assert GeoPartition.partition(shape, 10, :multipolygon) == %Geo.MultiPolygon{
        coordinates: [
          [
            [
              {-84.16557312011717, 36.887858857884986},
              {-84.15544774212663, 36.90341222036663},
              {-84.17381286621094, 36.91641125204138},
              {-84.23904418945313, 36.875775782851},
              {-84.16557312011717, 36.887858857884986}
            ]
          ],
          [
            [
              {-84.16557312011717, 36.887858857884986},
              {-84.14282165268783, 36.894475338928224},
              {-84.11407470703125, 36.87412794266634},
              {-84.16557312011717, 36.887858857884986}
            ]
          ],
          [
            [
              {-84.23904418945313, 36.875775782851},
              {-84.16557312011717, 36.887858857884986},
              {-84.11407470703125, 36.87412794266634},
              {-84.23904418945313, 36.875775782851}
            ]
          ],
          [
            [
              {-84.11407470703125, 36.87412794266634},
              {-84.17861938476563, 36.83401954216856},
              {-84.23904418945313, 36.875775782851},
              {-84.11407470703125, 36.87412794266634}
            ]
          ]
        ],
        properties: %{},
        srid: nil
      }
    end
  end
end
