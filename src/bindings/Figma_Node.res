type t
type _type = [#PAGE | #TEXT | #INSTANCE | #FRAME]

@get @return(nullable) external getChildren: t => option<array<t>> = "children"

@get @return(nullable) external getMainComponent: t => option<t> = "mainComponent"

@get @return(nullable) external getCharacters: t => option<string> = "characters"

@get external getName: t => string = "name"

@get external getType: t => _type = "type"

@get external getParent: t => option<t> = "parent"

@get external getX: t => int = "x"
@set external setX: (t, int) => unit = "x"

@get external getY: t => int = "y"
@set external setY: (t, int) => unit = "y"

@get external getHeight: t => int = "height"

@send external findAll: (t, t => bool) => array<t> = "findAll"

type findAllWithCriteriaOptions
@obj external findAllWithCriteriaOptions: (~types: array<_type>) => findAllWithCriteriaOptions = ""
@send
external findAllWithCriteria: (t, findAllWithCriteriaOptions) => array<t> = "findAllWithCriteria"

@send external appendChild: (t, t) => unit = "appendChild"

@send external insertCharacters: (t, int, string) => unit = "insertCharacters"

type layoutAlign = [#MIN | #CENTER | #MAX | #STRETCH | #INHERIT]
@set external setLayoutAlign: (t, layoutAlign) => unit = "layoutAlign"

type layoutMode = [#NONE | #HORIZONTAL | #VERTICAL]
@set external setLayoutMode: (t, layoutMode) => unit = "layoutMode"

type layoutPositioning = [#AUTO | #ABSOLUTE]
@set external setLayoutPositioning: (t, layoutPositioning) => unit = "layoutPositioning"

type sizingMode = [#FIXED | #AUTO]
@set external setPrimaryAxisSizingMode: (t, sizingMode) => unit = "primaryAxisSizingMode"
@set external setCounterAxisSizingMode: (t, sizingMode) => unit = "counterAxisSizingMode"

@set external setItemSpacing: (t, int) => unit = "itemSpacing"

@set external setPaddingLeft: (t, int) => unit = "paddingLeft"
@get external getPaddingLeft: t => int = "paddingLeft"
@set external setPaddingRight: (t, int) => unit = "paddingRight"
@get external getPaddingRight: t => int = "paddingRight"
@set external setPaddingTop: (t, int) => unit = "paddingTop"
@get external getPaddingTop: t => int = "paddingTop"
@set external setPaddingBottom: (t, int) => unit = "paddingBottom"
@get external getPaddingBottom: t => int = "paddingBottom"

@set external setFills: (t, array<Figma_Util.SolidPaint.t>) => unit = "fills"

@send external setPluginData: (t, string, string) => unit = "setPluginData"
@send external getPluginData: (t, string) => string = "getPluginData"

@send external remove: t => unit = "remove"
