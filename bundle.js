#!/usr/bin/env node

const esbuild = require("esbuild");
const path = require("node:path");

esbuild.buildSync({
  entryPoints: [path.resolve(__dirname, "./lib/es6/src/code.mjs")],
  bundle: true,
  format: "esm",
  outfile: path.resolve(__dirname, "./code.js"),
  minify: true,
});
