export {}

declare module "atom" {
  export class CompositeDisposable {
    add(disposable: AtomCore.Disposable)
    dispose()
  }

  export class Disposable {
    dispose()
  }

  var TextBuffer: {
    new (opts?: {filePath?: string; load?: boolean}): TextBuffer.ITextBuffer
  }
}
