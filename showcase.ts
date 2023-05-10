import WriterInit from "./writer.js"
import * as Path from "https://deno.land/std/path/mod.ts";
import { readLines } from "https://deno.land/std/io/read_lines.ts";

const w = await WriterInit();

let i = 0;
for await (const line of readLines(Deno.stdin)) {
  const j = JSON.parse(line);

  for await (const imgURL of j.image_paths) {
    const imgRes = await fetch(imgURL);
    if (!imgRes.ok) {
      console.log("Unable to download", j.id);
      continue;
    }
    const img = new Uint8Array(await imgRes.arrayBuffer());
    const pathParts = Path.parse(imgURL);
    const ext = j.image_paths.length === 1 ? pathParts.ext : "_" + pathParts.base;
    const out = "out/" + j.id + ext;
    const dc = {
      "dc.publisher" : "Midjourney",
      "dc.contributor": "Transfix Metadata Embed",
      "dc.creator" : j.username,
      "dc.date" : j.enqueue_time,
      "dc.title" : j.full_command,
      "dc.identifier" : j.id,
      "dc.source" : j.reference_job_id,
      "dc.subject" : j.prompt,
      "midjourney.data" : JSON.stringify(j),
      "xmp.BaseURL" : imgURL,
      "xmp.CreateDate" : new Date().toISOString().replaceAll(/[TZ]/ig, ' ').trimEnd(),
      "xmp.CreatorTool" : "Midjourney",
    }
    const p = w.writer(img, dc);
    Deno.writeFileSync(out, p);
    console.log(i, "Wrote", p.length, "to", out);
    i++;
  }
}
