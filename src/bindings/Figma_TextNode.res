type t

external fromNode: Figma_Node.t => t = "%identity"
external toNode: t => Figma_Node.t = "%identity"

let setFills = (text, fills) => {
  text->toNode->Figma_Node.setFills(fills)

  text
}

let insertCharacters = (text, characters, ~startIndex=0, ()) => {
  text->toNode->Figma_Node.insertCharacters(startIndex, characters)

  text
}
