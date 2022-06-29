open Figma
open Promise

figma->skipInvisibleInstanceChildren(true)

figma
->loadFontAsync(loadFontAsyncOptions(~family="Inter", ~style="Regular"))
->thenResolve(_ => {
  figma->getCurrentPage->Validator.do
})
->thenResolve(results => results->Array.forEach(Renderer.do))
->thenResolve(_ => {
  figma->closePluginWithMessage("Completed")
})
->ignore
