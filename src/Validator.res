type validateResult = {
  node: Figma.Node.t,
  comment: string,
}

let validateHeadingText = node => {
  let result = []

  node
  ->Figma.Node.findAllWithCriteria(Figma.Node.findAllWithCriteriaOptions(~types=[#TEXT]))
  ->Array.forEach(node => {
    if node->Figma.Node.getName == "HeadingText" {
      let characters = node->Figma.Node.getCharacters->Option.getExn

      [
        (%re(`/니다/`), `'~니다'체 보다는 '~해요'체를 사용하세요.`),
        (%re(`/\.$/`), `타이틀에서는 마침표를 찍지 않습니다.`),
        (%re(`/송금/`), `송금 -> 돈을 보냈어요`),
      ]->Array.forEach(((regExp, comment)) => {
        if regExp->Js.Re.test_(characters) {
          result
          ->Js.Array2.push({
            node: node,
            comment: comment,
          })
          ->ignore
        }
      })
    }
  })

  result
}

let do = node => {
  [validateHeadingText]->Array.map(validate => node->validate)->Array.concatMany
}
