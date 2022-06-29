open Figma

type result = {
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
