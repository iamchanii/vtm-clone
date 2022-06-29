module Node = Figma_Node
module FrameNode = Figma_FrameNode
module TextNode = Figma_TextNode
module Util = Figma_Util

type figma
@val external figma: figma = "figma"

/**
 * https://www.figma.com/plugin-docs/api/properties/figma-on
 */
type eventType = [#currentpagechange]
@send external on: (figma, eventType, unit => unit) => unit = "on"

/**
 * https://www.figma.com/plugin-docs/api/figma#currentpage
 */
@get external getCurrentPage: figma => Node.t = "currentPage"

/**
 * https://www.figma.com/plugin-docs/api/properties/figma-skipinvisibleinstancechildren/
 */
@set external skipInvisibleInstanceChildren: (figma, bool) => unit = "skipInvisibleInstanceChildren"

/**
 * https://www.figma.com/plugin-docs/api/properties/figma-closeplugin
 */
@send external closePlugin: figma => unit = "closePlugin"
@send external closePluginWithMessage: (figma, string) => unit = "closePlugin"

/**
 * https://www.figma.com/plugin-docs/api/properties/figma-createrectangle
 */
@send external createFrame: figma => FrameNode.t = "createFrame"
@send external createText: figma => TextNode.t = "createText"

/**
 * https://www.figma.com/plugin-docs/api/properties/figma-loadfontasync/
 */
type loadFontAsyncOptions
@obj external loadFontAsyncOptions: (~family: string, ~style: string) => loadFontAsyncOptions = ""
@send
external loadFontAsync: (figma, loadFontAsyncOptions) => Promise.t<unit> = "loadFontAsync"
