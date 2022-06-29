open Figma

%%private(
  let rec getParentFrame = node => {
    if node->Node.getType == #FRAME {
      Some(node->FrameNode.fromNode)
    } else {
      switch node->Node.getParent {
      | Some(parent) => parent->getParentFrame
      | _ => None
      }
    }
  }

  let pluginDataKey = "vtc-clone"
)

let do = (result: Validator.result) => {
  switch result.node->getParentFrame {
  | None => Js.Console.warn(`Node's parent frame is not exist. skipped.`)
  | Some(parentFrame) => {
      let frame = figma->createFrame
      parentFrame->FrameNode.appendChild(frame->FrameNode.toNode)->ignore

      // To identify what is the frame node created by the plugin in cleanup phase.
      frame->FrameNode.toNode->Node.setPluginData(pluginDataKey, "yes")

      frame
      ->FrameNode.setPadding(6)
      ->FrameNode.setItemSpacing(2)
      ->FrameNode.setFills([
        // ORANGE 7
        // from https://yeun.github.io/open-color/#orange
        Util.Rgb.fromInt(~r=247, ~g=103, ~b=7)->Util.SolidPaint.fromRgb,
      ])
      ->FrameNode.setLayout(
        ~layoutMode=#VERTICAL,
        ~layoutAlign=#STRETCH,
        ~layoutPositioning=#ABSOLUTE,
        ~primaryAxisSizingMode=#AUTO,
        ~counterAxisSizingMode=#AUTO,
        (),
      )
      ->FrameNode.setPosition(
        ~y={
          let parentFramePaddingTop = parentFrame->FrameNode.toNode->Node.getPaddingTop
          let instanceNodeHeight = result.node->Node.getHeight
          let correction = 8 // for looks good ;)

          parentFramePaddingTop + instanceNodeHeight + correction
        },
        (),
      )
      ->ignore

      result.comments->Array.forEach(comment => {
        let text =
          figma
          ->createText
          ->TextNode.insertCharacters("- " ++ comment, ())
          ->TextNode.setFills([Util.Rgb.white->Util.SolidPaint.fromRgb])

        frame->FrameNode.appendChild(text->TextNode.toNode)->ignore
      })
    }
  }
}

let cleanup = () => {
  let previousCommentFrames =
    figma
    ->getCurrentPage
    ->Node.findAllWithCriteria(Node.findAllWithCriteriaOptions(~types=[#FRAME]))
    ->Array.keep(node => node->Node.getPluginData(pluginDataKey) != "")
  let previousCommentFrameCount = previousCommentFrames->Array.length

  if previousCommentFrameCount > 0 {
    previousCommentFrames->Array.forEach(node => node->Node.remove)
    Js.log(`Remove previous comment ${previousCommentFrameCount->Int.toString} node(s).`)
  }
}
