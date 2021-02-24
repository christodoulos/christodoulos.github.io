mermaid.initialize({
  startOnLoad: false,
  cloneCssStyles: false,
  theme: "neutral"
});
slideshow.on("afterShowSlide", s => {
  for (const d of document.querySelectorAll("div.mermaid")) {
    if (d.offsetWidth > 0) mermaid.init(undefined, d);
  }
});
