open Figma
open Promise

figma->skipInvisibleInstanceChildren(true)

figma
->loadFontAsync(loadFontAsyncOptions(~family="Inter", ~style="Regular"))
->thenResolve(_ => {
  figma->getCurrentPage->Validator.do->Array.forEach(Validator.draw)
})
->thenResolve(_ => {
  figma->closePluginWithMessage("Completed")
})
->ignore
