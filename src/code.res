open Figma
open Promise

figma->skipInvisibleInstanceChildren(true)

Renderer.cleanup()

figma
->loadFontAsync(loadFontAsyncOptions(~family="Inter", ~style="Regular"))
->thenResolve(_ => figma->getCurrentPage->Validator.do)
->thenResolve(results => {
  let resultCount = results->Array.length
  if resultCount > 0 {
    results->Array.forEach(Renderer.do)
    figma->closePluginWithMessage(`There is ${resultCount->Int.toString} issue(s).`)
  } else {
    figma->closePluginWithMessage("Looks good to me!")
  }
})
->ignore
