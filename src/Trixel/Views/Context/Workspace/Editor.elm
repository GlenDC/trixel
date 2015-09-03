module Trixel.Views.Context.Workspace.Editor (view) where

import Trixel.Models.Model as TrModel

import Trixel.Types.Layout as TrLayout

import Trixel.Glue.Hacks as TrHacks

import WebGL as GL

import Math.Vector4 exposing (..)
import Math.Vector3 exposing (..)
import Math.Vector2 exposing (..)
import Math.Matrix4 as Mat4

import Html


view : TrModel.Model -> TrLayout.Mode -> Html.Html
view model mode =
  let (w, h) = TrHacks.getViewportDimensions model.dom.tags.workspace
      matrix = ortho2D w h
  in
    GL.webglWithConfig
      [ GL.Enable GL.Blend
      , GL.Disable GL.DepthTest
      , GL.BlendEquation GL.Add
      , GL.BlendFunc (GL.SrcAlpha, GL.OneMinusSrcAlpha)
      ]
      (w, h)
      [ GL.render
          vertexShader
          fragmentShader
          mesh
          { mat = (Mat4.translate (vec3 50 50 0) matrix) }
      ]
    |> Html.fromElement


type alias Vertex =
  { position : Vec2
  , color : Vec4
  }


mesh : GL.Drawable Vertex
mesh =
  List.foldl
    (++)
    []
    [
      [ ( Vertex (vec2 0 0) (vec4 0 0 1 0.25)
        , Vertex (vec2 200 0) (vec4 0 0 1 0.25)
        , Vertex (vec2 100 200) (vec4 0 0 1 0.25)
        ),
        ( Vertex (vec2 0 200) (vec4 1 0 0 1)
        , Vertex (vec2 200 200) (vec4 1 0 0 1)
        , Vertex (vec2 100 0) (vec4 1 0 0 1)
        )
      ],
      [ ( Vertex (vec2 100 0) (vec4 0 1 0 0.5)
        , Vertex (vec2 300 0) (vec4 0 1 0 0.5)
        , Vertex (vec2 200 200) (vec4 0 1 0 0.5)
        ),
        ( Vertex (vec2 100 200) (vec4 0 0 1 0.5)
        , Vertex (vec2 300 200) (vec4 0 0 1 0.5)
        , Vertex (vec2 200 0) (vec4 0 0 1 0.5)
        )
      ]
    ]
  |> GL.Triangle


ortho2D : Int -> Int -> Mat4.Mat4
ortho2D w h =
  Mat4.makeOrtho2D 0 (toFloat w) (toFloat h) 0
  |> Mat4.translate (vec3 200 200 0)
  |> Mat4.scale (vec3 1.5 1.5 1.0)


vertexShader : GL.Shader { attr | position:Vec2, color: Vec4 } { unif | mat:Mat4.Mat4 } { vcolor:Vec4 }
vertexShader = [glsl|

attribute vec2 position;
attribute vec4 color;
uniform mat4 mat;
varying vec4 vcolor;

void main(void) {
  gl_Position = mat * vec4(position, 1.0, 1.0);
  vcolor = color;
}
|]


fragmentShader : GL.Shader {} u { vcolor:Vec4 }
fragmentShader = [glsl|

precision mediump float;
varying vec4 vcolor;

void main(void) {
  gl_FragColor = vcolor;
}

|]
