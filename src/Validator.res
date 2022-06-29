open Figma

type result = {
  node: Node.t,
  comments: array<string>,
}

type rule = (Js.Re.t, string)

module type RuleConfig = {
  type t

  let rules: array<rule>
  let toNode: t => Node.t
  let predicate: Node.t => option<t>
  let getCharacters: t => string
}

module DefaultRuleConfig = {
  let predicate = node => Some(node)
  let getCharacters = node => node->Node.getCharacters
}

module Rule = (RuleConfig: RuleConfig) => {
  let do = () => {
    figma
    ->getCurrentPage
    ->Node.findAllWithCriteria(Node.findAllWithCriteriaOptions(~types=[#TEXT]))
    ->Array.keepMap(RuleConfig.predicate)
    ->Array.keepMap(node => {
      let characters = node->RuleConfig.getCharacters
      let violationComments = RuleConfig.rules->Array.keepMap(((rule, comment)) =>
        switch rule->Js.Re.test_(characters) {
        | true => Some(comment)
        | _ => None
        }
      )

      switch violationComments->Array.length {
      | 0 => None
      | _ => Some({node: node->RuleConfig.toNode, comments: violationComments})
      }
    })
  }
}

module HeadingTextRule = Rule({
  type t = TextNode.t
  let rules = [
    (%re(`/니다/`), `'~니다'체 보다는 '~해요'체를 사용하세요.`),
    (%re(`/\.$/`), `타이틀에서는 마침표를 찍지 않습니다.`),
  ]
  let toNode = TextNode.toNode
  let predicate = node =>
    switch node->Node.getName == "HeadingText" {
    | true => Some(node->TextNode.fromNode)
    | _ => None
    }
  let getCharacters = TextNode.getCharacters
})

module TextRule = Rule({
  type t = Node.t
  let rules = [(%re(`/송금/`), `송금 -> 돈을 보냈어요`)]
  let toNode = node => node
  let predicate = node => Some(node)
  let getCharacters = node => node->Node.getCharacters
})

let do = () => {
  module ResultPairComparator = Id.MakeComparable({
    type t = result
    let cmp = (a, b) => Pervasives.compare(a.node->Node.getId, b.node->Node.getId)
  })

  let result = ref(Set.make(~id=module(ResultPairComparator)))

  [HeadingTextRule.do(), TextRule.do()]
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
