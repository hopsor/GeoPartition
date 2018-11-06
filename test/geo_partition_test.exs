defmodule GeoPartitionTest do
  use ExUnit.Case
  doctest GeoPartition

  @string """
  [
  {
    "type": "Feature",
    "properties": {
      "area": 8635913.881097274
    },
    "geometry": {
      "type": "MultiPolygon",
      "coordinates": [
        [
          [
            [
              -85.76837539672852,
              38.24438205858283
            ],
            [
              -85.78210830688477,
              38.22442610753021
            ],
            [
              -85.75052261352539,
              38.236157634068825
            ],
            [
              -85.7567024230957,
              38.21660403859855
            ],
            [
              -85.72151184082031,
              38.23858461019401
            ],
            [
              -85.73284149169922,
              38.25368397473024
            ],
            [
              -85.75824737548828,
              38.24222492249137
            ],
            [
              -85.76837539672852,
              38.24438205858283
            ]
          ]
        ]
      ]
    }
  },
  {
    "type": "Feature",
    "properties": {
      "area": 8635913.881097274
    },
    "geometry": {
      "type": "MultiPolygon",
      "coordinates": [
        [
          [
            [
              -85.76837539672852,
              38.24438205858283
            ],
            [
              -85.78210830688477,
              38.22442610753021
            ],
            [
              -85.75052261352539,
              38.236157634068825
            ],
            [
              -85.7567024230957,
              38.21660403859855
            ],
            [
              -85.72151184082031,
              38.23858461019401
            ],
            [
              -85.73284149169922,
              38.25368397473024
            ],
            [
              -85.75824737548828,
              38.24222492249137
            ],
            [
              -85.76837539672852,
              38.24438205858283
            ]
          ]
        ]
      ]
    }
  }
]
  """

  describe "partition" do
    test "whole list string" do
      assert GeoPartition.partition(@string) == ["good", "good"]
    end
  end
end
