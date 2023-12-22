import { fail } from "https://deno.land/std@0.209.0/assert/mod.ts";

console.log("build arch: %s", Deno.build.arch);
if (!Deno.build.arch || Deno.build.arch == "") {
    fail(`invalid arch "${Deno.build.arch}"`);
}
