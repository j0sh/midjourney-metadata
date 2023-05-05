 import WriterInit from "./writer.js"
 import * as Path from "https://deno.land/std/path/mod.ts";

const w = await WriterInit();
const fname = Deno.args[0];
const d = Deno.readFileSync(fname);
const ext = Path.extname(fname);
const out = "out" + ext;

const p = w.writer(d);
Deno.writeFileSync(out, p);

console.log("Wrote", p.length, "to", out);

