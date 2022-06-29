open Figma

type validateResult = {
  node: Node.t,
  comments: array<string>,
}

let validateHeadingText = node => {
  let result = []

  node
  ->Node.findAllWithCriteria(Node.findAllWithCriteriaOptions(~types=[#TEXT]))
  ->Array.forEach(node => {
    if node->Node.getName == "HeadingText" {
      let characters = node->Node.getCharacters->Option.getExn
      let comments = [
        (%re(`/니다/`), `'~니다'체 보다는 '~해요'체를 사용하세요.`),
        (%re(`/\.$/`), `타이틀에서는 마침표를 찍지 않습니다.`),
        (%re(`/송금/`), `송금 -> 돈을 보냈어요`),
      ]->Array.keepMap(((regExp, comment)) => {
        if regExp->Js.Re.test_(characters) {
          Some(comment)
        } else {
          None
        }
      })

      switch comments->Array.length {
      | 0 => ()
      | _ => result->Js.Array2.push({node: node, comments: comments})->ignore
      }
    }
  })

  result
}

let do = node => {
  [validateHeadingText]->Array.map(validate => node->validate)->Array.concatMany
}

let rec getParentFrame = node => {
  if node->Node.getType == #FRAME {
    Some(node)
  } else {
    switch node->Node.getParent {
    | Some(parent) => parent->getParentFrame
    | _ => None
    }
  }
}

let draw = result => {
  let frame = figma->createFrame
  let parentFrame = result.node->getParentFrame->Option.getExn
  parentFrame->Node.appendChild(frame)
  frame->Node.setLayoutPositioning(#ABSOLUTE)

  frame->Node.setLayoutMode(#VERTICAL)
  frame->Node.setLayoutAlign(#STRETCH)
  frame->Node.setPrimaryAxisSizingMode(#AUTO)
  frame->Node.setCounterAxisSizingMode(#AUTO)
  frame->Node.setItemSpacing(2)
  frame->Node.setPaddingLeft(6)
  frame->Node.setPaddingRight(6)
  frame->Node.setPaddingTop(6)
  frame->Node.setPaddingBottom(6)
  frame->Node.setFills([
    {
      "type": "SOLID",
      "color": {
        "r": 247.0 /. 255.0,
        "g": 103.0 /. 255.0,
        "b": 7.0 /. 255.0,
      },
    },
  ])
  Js.log(`result height: ${result.node->Node.getHeight->Int.toString}`)
  Js.log(`result y: ${result.node->Node.getY->Int.toString}`)
  frame->Node.setY(
    parentFrame->Node.getPaddingTop + result.node->Node.getY + result.node->Node.getHeight,
  )

  result.comments->Array.forEach(comment => {
    let text = figma->createText
    text->Node.insertCharacters(0, comment)
    text->Node.setFills([
      {
        "type": "SOLID",
        "color": {
          "r": 1,
          "g": 1,
          "b": 1,
        },
      },
    ])
    frame->Node.appendChild(text)
  })
}
