type t
type _type = [#PAGE | #TEXT | #INSTANCE]

@get @return(nullable) external getChildren: t => option<array<t>> = "children"

@get @return(nullable) external getMainComponent: t => option<t> = "mainComponent"

@get @return(nullable) external getCharacters: t => option<string> = "characters"

@get external getName: t => string = "name"

@get external getType: t => _type = "type"

@send external findAll: (t, t => bool) => array<t> = "findAll"

type findAllWithCriteriaOptions
@obj external findAllWithCriteriaOptions: (~types: array<_type>) => findAllWithCriteriaOptions = ""
@send
external findAllWithCriteria: (t, findAllWithCriteriaOptions) => array<t> = "findAllWithCriteria"
