open Figma

type result = {
  node: Node.t,
  comments: array<string>,
}

type rule = (Js.Re.t, string)

let validateHeadingText = () => {
  let keepHeadingText = node =>
    switch node->Node.getName == "HeadingText" {
    | true => Some(node->TextNode.fromNode)
    | _ => None
    }

  let rules = [
    (%re(`/니다/`), `'~니다'체 보다는 '~해요'체를 사용하세요.`),
    (%re(`/\.$/`), `타이틀에서는 마침표를 찍지 않습니다.`),
  ]

  figma
  ->getCurrentPage
  ->Node.findAllWithCriteria(Node.findAllWithCriteriaOptions(~types=[#TEXT]))
  ->Array.keepMap(keepHeadingText)
  ->Array.keepMap(node => {
    let characters = node->TextNode.getCharacters
    let violationComments = rules->Array.keepMap(((rule, comment)) =>
      switch rule->Js.Re.test_(characters) {
      | true => Some(comment)
      | _ => None
      }
    )

    switch violationComments->Array.length {
    | 0 => None
    | _ => Some({node: node->TextNode.toNode, comments: violationComments})
    }
  })
}

let validateText = () => {
  let rules = [(%re(`/송금/`), `송금 -> 돈을 보냈어요`)]

  figma
  ->getCurrentPage
  ->Node.findAllWithCriteria(Node.findAllWithCriteriaOptions(~types=[#TEXT]))
  ->Array.keepMap(node => {
    let characters = node->TextNode.fromNode->TextNode.getCharacters
    let violationComments = rules->Array.keepMap(((rule, comment)) =>
      switch rule->Js.Re.test_(characters) {
      | true => Some(comment)
      | _ => None
      }
    )

    switch violationComments->Array.length {
    | 0 => None
    | _ => Some({node: node, comments: violationComments})
    }
  })
}

let do = () => {
  module ResultPairComparator = Id.MakeComparable({
    type t = result
    let cmp = (a, b) => Pervasives.compare(a.node->Node.getId, b.node->Node.getId)
  })

  let result = ref(Set.make(~id=module(ResultPairComparator)))

  [validateHeadingText(), validateText()]
  ->Array.concatMany
  ->Array.forEach(validationResult =>
    switch result.contents->Set.has(validationResult) {
    | false => result := result.contents->Set.add(validationResult)
    | true => {
        let storedResult = result.contents->Set.get(validationResult)->Option.getUnsafe

        result := result.contents->Set.remove(validationResult)
        result :=
          result.contents->Set.add({
            node: validationResult.node,
            comments: [storedResult.comments, validationResult.comments]->Array.concatMany,
          })
      }
    }
  )

  result.contents->Set.toArray
}
