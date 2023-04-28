# midjourney-metadata

Never lose track of [Midjourney](http://midjourney.com) prompts again. Embed job parameters as image metadata with this Chrome extension.

![Leprechaun mother and her three children guarding a pot full of gold on the irish seashore. painting by alan maley](https://user-images.githubusercontent.com/292510/235260517-9b288ebb-1d72-4d9a-84ba-cee477b30cf8.png)


### Why? 

People often share their MJ-generated images, but not the prompts. The Midjourney web UI will show most parts of prompts, but that gets lost if you download the image, unless extra effort is made to separately track the prompts. Moreover, there is usually other job metadata that can be relevant: user name, seed value, etc.

By embedding job parameters within the image metadata, the prompt can travel with the image. There are many benefits to this:

- Improves distribution: the image and the metadata are in one package
- Improves accessibility: alt tags and similar can be made from prompts
- Improves transparency: with more AI-generated content, provenance becomes more relevant. Where did this image come from, and how was it generated?
- Reinforces community: The MJ ethos is open-by-default and sharing job parameters helps to reinforce that. 
- Improves learning: studying the work of others is a great way to learn about how to use a system, and MJ prompts are no exception.
- Unlocks other use cases: your imagination is the limit.

Hopefully one day metadata embedding will be a feature native to MJ. Until then, this project can fill in those gaps.

### Goals

Current goal is to make this a (desktop) Chrome extension.
- Single click to embed and download all image assets on a MJ page
- Embed and download single images
  - combo of mouse-over + right-click
  - mouse-over + hotkeys
  
Run 100% locally - JS + WASM

### MVP to Product:
- [x] bash script to scrape MJ community page and embed metadata
- [ ] Deno + wasm version of the script
- [ ] Chrome extension


### TODO
- [x] Scrape MJ community page
- [ ] Scrape MJ personal pages
- [ ] wasm build for exiv2 (see  [4/28 standup notes](https://github.com/j0sh/daily-standup/blob/main/README.md#28-april-2023) for details)
- [ ] single image embedding + downloads
- [ ] zip downloads ([jszip](https://stuk.github.io/jszip/)?)
- [ ] chrome extension
- [ ] hotkey support
