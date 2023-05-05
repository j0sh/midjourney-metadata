import ReaderInit from "./reader.js"

const r = await ReaderInit();
const d = Deno.readFileSync(Deno.args[0]);
console.log(r.reader(d));
