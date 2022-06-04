const puppeteer = require('puppeteer');

var args = process.argv.slice(2);
var sterm = args[0];

(async () => {
  browser = await puppeteer.launch();
  const [page] = await browser.pages();
  await page.goto("https://www.google.com/", {waitUntil: "domcontentloaded"});
  await page.waitForSelector('input[aria-label="Search"]', {visible: true});
  await page.type('input[aria-label="Search"]', sterm);
  await Promise.all([
    page.waitForNavigation(),
    page.keyboard.press("Enter"),
  ]);
  await page.waitForSelector(".LrzXr", {visible: true});
  const searchResults = await page.$$eval(".LrzXr", els =>
    els.map(e => e.innerHTML)[0]
  );
  console.log(searchResults);
})()
  .catch(err => console.error(err))
  .finally(() => browser?.close())
;