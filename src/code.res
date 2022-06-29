open Figma
open Promise

figma->skipInvisibleInstanceChildren(true)

Renderer.cleanup()

figma
->loadFontAsync(loadFontAsyncOptions(~family="Inter", ~style="Regular"))
->thenResolve(_ => {
  let results = Validator.do()

  switch results->Array.length {
  | 0 => figma->closePluginWithMessage("Looks good to me!")
  | count => {
      results->Array.forEach(Renderer.do)
      figma->closePluginWithMessage(`There is ${count->Int.toString} issue(s).`)
    }
  }
})
->ignore
