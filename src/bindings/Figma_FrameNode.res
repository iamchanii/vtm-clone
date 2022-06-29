type t

external fromNode: Figma_Node.t => t = "%identity"
external toNode: t => Figma_Node.t = "%identity"

let setPadding = (frame, int) => {
  let node = frame->toNode
  node->Figma_Node.setPaddingTop(int)
  node->Figma_Node.setPaddingRight(int)
  node->Figma_Node.setPaddingBottom(int)
  node->Figma_Node.setPaddingLeft(int)

  frame
}

let setItemSpacing = (frame, int) => {
  frame->toNode->Figma_Node.setItemSpacing(int)

  frame
}

let setLayout = (
  frame,
  ~layoutMode=?,
  ~layoutAlign=?,
  ~layoutPositioning=?,
  ~primaryAxisSizingMode=?,
  ~counterAxisSizingMode=?,
  (),
) => {
  let node = frame->toNode

  switch layoutMode {
  | Some(layoutMode) => node->Figma_Node.setLayoutMode(layoutMode)
  | _ => ()
  }

  switch layoutAlign {
  | Some(layoutAlign) => node->Figma_Node.setLayoutAlign(layoutAlign)
  | _ => ()
  }

  switch layoutPositioning {
  | Some(layoutPositioning) => node->Figma_Node.setLayoutPositioning(layoutPositioning)
  | _ => ()
  }

  switch primaryAxisSizingMode {
  | Some(primaryAxisSizingMode) => node->Figma_Node.setPrimaryAxisSizingMode(primaryAxisSizingMode)
  | _ => ()
  }

  switch counterAxisSizingMode {
  | Some(counterAxisSizingMode) => node->Figma_Node.setCounterAxisSizingMode(counterAxisSizingMode)
  | _ => ()
  }

  frame
}

let setFills = (frame, fills) => {
  frame->toNode->Figma_Node.setFills(fills)

  frame
}

let setPosition = (frame, ~x=?, ~y=?, ()) => {
  let node = frame->toNode

  switch x {
  | Some(x) => node->Figma_Node.setX(x)
  | _ => ()
  }

  switch y {
  | Some(y) => node->Figma_Node.setY(y)
  | _ => ()
  }

  frame
}

let appendChild = (frame, node) => {
  frame->toNode->Figma_Node.appendChild(node)

  frame
}
