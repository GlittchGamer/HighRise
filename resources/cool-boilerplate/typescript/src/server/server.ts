onNet("add", async () => {
  const source = global.source;
  console.log("Source:", source);

  const char = global.exports['core'].FetchSource(source).GetData('Character');

  console.log("Character:", char);

});