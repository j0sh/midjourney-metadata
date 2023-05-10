import WriterInit from "./writer.js"
import * as Path from "https://deno.land/std/path/mod.ts";
import DiffusionInfo from "./cassatt.json" assert { type: "json" };

 // most these fields taken from "dublin core"
 const dc = {
   "dc.publisher" : "Midjourney",
   "dc.contributor": "Transfix Metadata Embed",
   "dc.creator" : DiffusionInfo.username,
   "dc.date" : DiffusionInfo.enqueue_time,
   "dc.title" : DiffusionInfo.full_command,
   "dc.identifier" : DiffusionInfo.id,
   "dc.source" : DiffusionInfo.reference_job_id,
   "dc.subject" : DiffusionInfo.prompt,
   "midjourney.data" : JSON.stringify(DiffusionInfo),
}

const w = await WriterInit();
const fname = Deno.args[0];
const d = Deno.readFileSync(fname);
const ext = Path.extname(fname);
const out = "out" + ext;

const p = w.writer(d, dc);
Deno.writeFileSync(out, p);

console.log("Wrote", p.length, "to", out);

