module Trixel.ColorScheme where

import Color exposing (Color, rgba)

type alias ColorInfo = { elm: Color, html: String }

type alias ColorScheme = {
  bg: ColorInfo,
  fg: ColorInfo,
  subbg: ColorInfo,
  subfg: ColorInfo,
  selbg: ColorInfo,
  selfg: ColorInfo
}

createColorInfo: Int -> Int -> Int -> Int -> ColorInfo
createColorInfo r g b a =
  { elm = rgba r g b ((toFloat a) / 255),
    html = "rgba(" ++ (toString r) ++ "," ++
       (toString g) ++ "," ++ (toString b) ++ "," ++ (toString a) ++ ")"
  }

zenburnScheme: ColorScheme
zenburnScheme =
  { bg = createColorInfo 64 64 64 255,
    fg = createColorInfo 246 243 232 255,
    subbg = createColorInfo 40 40 40 255,
    subfg = createColorInfo 225 230 210 255,
    selbg = createColorInfo 137 137 65 255,
    selfg = createColorInfo 0 0 0 2555
  }

{-
<?xml version="1.0" encoding="utf-8"?>
<colorTheme id="2" name="Zenburn" modified="2011-02-09 14:16:09" author="Janni Nurminen" website="http://slinky.imukuppi.org/2006/10/31/just-some-alien-fruit-salad-to-keep-you-in-the-zone/">
    <searchResultIndication color="#464467" />
    <filteredSearchResultIndication color="#3F3F6A" />
    <occurrenceIndication color="#616161" />
    <writeOccurrenceIndication color="#948567" />
    <findScope color="#BCADAD" />
    <sourceHoverBackground color="#A19879" />
    <singleLineComment color="#7F9F7F" bold="false" />
    <multiLineComment color="#7F9F7F" />
    <commentTaskTag color="#ACC1AC" bold="false" />
    <javadoc color="#B3B5AF" />
    <javadocLink color="#A893CC" />
    <javadocTag color="#9393CC" />
    <javadocKeyword color="#CC9393" />
    <class color="#CAE682" />
    <interface color="#CAE682" />
    <method color="#DFBE95" />
    <methodDeclaration color="#DFBE95" />
    <bracket color="#FFFFFF" />
    <number color="#8ACCCF" />
    <string color="#CC9393" />
    <operator color="#F0EFD0" />
    <keyword color="#EFEFAF" />
    <annotation color="#808080" />
    <staticMethod color="#C4C4B7" />
    <localVariable color="#D4C4A9" />
    <localVariableDeclaration color="#D4C4A9" bold="false" />
    <field color="#B3B784" bold="false" />
    <staticField color="#93A2CC" bold="false" />
    <staticFinalField color="#53DCCD" bold="false" />
    <deprecatedMember color="#FFFFFF" bold="false" />
    <background color="#404040" /> 040404F0
    <currentLine color="#505050" />
    <foreground color="#F6F3E8" />
    <lineNumber color="#C0C0C0" />
    <selectionBackground color="#898941" />
    <selectionForeground color="#000000" />
</colorTheme>
-}