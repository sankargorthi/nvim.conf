; Inject markdown into `///` and `//!` doc-comment content so render-markdown
; (and any other markdown-aware plugin) can decorate headings, inline code,
; bold/italic, links, and lists inside Rust doc comments.
;
; The tree-sitter-rust grammar exposes a `doc_comment` node that contains the
; comment text after the `///`/`//!` marker. The base injections.scm shipped
; with nvim-treesitter only injects `comment` (TODO/FIXME highlighter) into
; line_comment/block_comment; this file supplements — not replaces — that,
; because nvim runtime merges `after/queries/*` on top of the base queries.

((doc_comment) @injection.content
  (#set! injection.language "markdown"))
