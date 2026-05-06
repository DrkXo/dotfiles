const express = require("express");
const puppeteer = require("puppeteer-extra");
const StealthPlugin = require("puppeteer-extra-plugin-stealth");
const AdblockerPlugin = require("puppeteer-extra-plugin-adblocker");
puppeteer.use(StealthPlugin());
puppeteer.use(AdblockerPlugin({ blockTrackers: true }));

const { JSDOM } = require("jsdom");
const { Readability } = require("@mozilla/readability");
const HTMLtoDOCX = require("@turbodocx/html-to-docx");
const app = express();
app.use(express.json());

// ─── Constants ────────────────────────────────────────────────────────────────

const NAVIGATION_TIMEOUT = 30000;
const CONTENT_WAIT_TIMEOUT = 5000;

// User agents to rotate
const USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0",
];

// Site-specific selectors: try these before Readability as a fallback
const SITE_SELECTORS = {
    "thedailystar.net":   "article.article-content, div.article-content",
    "prothomalo.com":     "div.story-element, div[class*='story']",
    "aljazeera.com":      "div.article__body, div[class*='wysiwyg']",
    "theguardian.com":    "div.article-body-commercial-selector, div[data-gu-name='body']",
    "thehindu.com":       "div[id='content-body-14269002-14269004'], div.article-section",
    "timesofindia.indiatimes.com": "div.ga-headlines, div[class*='article_content'], div._s30J",
    "ndtv.com":           "div.article__storybody, div[itemprop='articleBody']",
    "hindustantimes.com": "div.storyDetails, div[class*='storyDetails']",
    "livemint.com":       "div.mainArea, div[class*='contentSec']",
    "economictimes.indiatimes.com": "div.artText, div[class*='article_wrap']",
    "theprint.in":        "div.entry-content",
    "wionews.com":        "div.article-content, div[class*='article-body']",
    "irrawaddy.com":      "div.entry-content",
    "bdnews24.com":       "div.article-body, div[class*='print_news']",
    "tbsnews.net":        "div.article-body, div[class*='single-post-content']",
    "newagebd.net":       "div#article, div.article-details",
    "thefinancialexpress.com.bd": "div.content-details, div[class*='details-body']",
};

// Sites that need JS-heavy waiting (SPA or lazy loaders)
const JS_HEAVY_SITES = [
    "aljazeera.com", "theguardian.com", "wionews.com", "msn.com",
"outlookindia.com", "news18.com", "moneycontrol.com",
];

// Sites with known cookie/consent banners to dismiss
const COOKIE_BANNER_SELECTORS = [
    "#onetrust-accept-btn-handler",
"#accept-recommended-btn-handler",
"button[id*='accept']",
"button[class*='accept']",
"button[class*='consent']",
"button[class*='agree']",
"[aria-label*='Accept']",
".cc-btn.cc-allow",
"#CybotCookiebotDialogBodyButtonAccept",
];

// ─── Helpers ──────────────────────────────────────────────────────────────────

function randomUserAgent() {
    return USER_AGENTS[Math.floor(Math.random() * USER_AGENTS.length)];
}

function getDomain(url) {
    try {
        return new URL(url).hostname.replace(/^www\./, "");
    } catch {
        return "";
    }
}

function isJSHeavy(url) {
    const domain = getDomain(url);
    return JS_HEAVY_SITES.some((d) => domain.includes(d));
}

function getSiteSelector(url) {
    const domain = getDomain(url);
    for (const [key, selector] of Object.entries(SITE_SELECTORS)) {
        if (domain.includes(key)) return selector;
    }
    return null;
}

// Remove inline ad scripts, interstitials, ad containers, and stray CSS from HTML
function cleanAdContent(html) {
    const dom = new JSDOM(html);
    const doc = dom.window.document;

    // Remove all <script> tags
    doc.querySelectorAll("script").forEach((el) => el.remove());

    // Remove <noscript> tags (often contain ad fallbacks)
    doc.querySelectorAll("noscript").forEach((el) => el.remove());

    // Remove <style> tags (inline CSS leaking into content)
    doc.querySelectorAll("style").forEach((el) => el.remove());

    // Remove elements with ad-related class/id/attribute patterns
    const adSelectors = [
        "[class*='ad-']", "[class*='ad_']", "[class*='Ad-']", "[class*='Ad_']",
        "[id*='ad-']", "[id*='ad_']", "[id*='Ad-']", "[id*='Ad_']",
        "[class*='advert']", "[class*='sponsor']", "[class*='Interstitial']",
        "[class*='interstitial']", "[id*='Interstitial']", "[id*='interstitial']",
        "[class*='googletag']", "[class*='gpt-ad']",
        "[data-ad-slot]", "[data-ad-client]", "[data-ad-container]",
        ".ad-unit", ".ad-container", ".ad-wrapper", ".ad-slot",
        "#ad-container", "#ad-wrapper", "#ad-unit",
        ".dfp-ad", ".google-ads", ".ad-banner",
        // Widget / stock ticker / liveblog sections that leak CSS
        ".onDemand", "#sr_widget", "#stock_pro", ".live_stock",
        ".bgBig", ".lb-icon",
    ];

    for (const selector of adSelectors) {
        try {
            doc.querySelectorAll(selector).forEach((el) => el.remove());
        } catch {}
    }

    // Remove text nodes that contain ad code or raw CSS (sites like The Hindu embed these as raw text)
    const walker = doc.createTreeWalker(doc.body, dom.window.NodeFilter.SHOW_TEXT);
    const nodesToRemove = [];
    const adPatterns = [
        /googletag\./,
        /getStorage\(/,
        /setStorage\(/,
        /isDeviceEnabled\(/,
        /isNonSubcribedUser\(\)/,
        /googletag\.cmd\.push/,
        /defineOutOfPageSlot/,
        /\.addService\(googletag\.pubads\(\)\)/,
        /googletag\.display\(/,
    ];

    let node;
    while ((node = walker.nextNode())) {
        const text = node.textContent.trim();
        // Raw CSS blocks: lines with CSS selectors/properties
        const cssPattern = /^[\s#\.]?[\w\-#\.]+\s*\{[^}]*\}[\s#\.]?[\w\-#\.]*\s*\{[^}]*\}/m;
        const looksLikeRawCss = /#[\w\-]+\.[\w\-]+\s*\{/.test(text) || cssPattern.test(text);
        if (
            (text.length > 50 && adPatterns.some((p) => p.test(text))) ||
            (text.length > 50 && looksLikeRawCss)
        ) {
            nodesToRemove.push(node);
        }
    }

    nodesToRemove.forEach((n) => n.remove());

    return doc.body.innerHTML || "";
}

async function dismissCookieBanners(page) {
    for (const selector of COOKIE_BANNER_SELECTORS) {
        try {
            const btn = await page.$(selector);
            if (btn) {
                await btn.click();
                await new Promise((r) => setTimeout(r, 500));
                break;
            }
        } catch {
            // ignore — banner may not exist
        }
    }
}

async function extractWithSelector(page, selector) {
    try {
        const content = await page.$eval(selector, (el) => el.innerHTML);
        return content || null;
    } catch {
        return null;
    }
}

async function extractArticle(html, url) {
    const dom = new JSDOM(html, { url });
    const article = new Readability(dom.window.document).parse();
    return article;
}

// ─── Browser Pool (reuse browser across requests) ─────────────────────────────

let browserInstance = null;
let browserUseCount = 0;
const BROWSER_RECYCLE_AFTER = 20; // recycle browser every N requests

async function getBrowser() {
    if (!browserInstance || browserUseCount >= BROWSER_RECYCLE_AFTER) {
        if (browserInstance) {
            try { await browserInstance.close(); } catch {}
        }
        browserInstance = await puppeteer.launch({
            headless: "new",
            args: [
                "--no-sandbox",
                "--disable-setuid-sandbox",
                "--disable-dev-shm-usage",
                "--disable-accelerated-2d-canvas",
                "--disable-gpu",
                "--no-zygote",
                "--single-process",
                "--disable-extensions",
                "--disable-background-networking",
                "--disable-default-apps",
                "--mute-audio",
                "--no-first-run",
            ],
        });
        browserUseCount = 0;
    }
    browserUseCount++;
    return browserInstance;
}

// ─── Main Scrape Route ────────────────────────────────────────────────────────

app.post("/scrape", async (req, res) => {
    const { url, force_readability = false } = req.body;

    if (!url) {
        return res.status(400).json({ error: "Missing required field: url" });
    }

    // Reject non-article URLs like x.com or t.me early
    const domain = getDomain(url);
    const NON_ARTICLE_DOMAINS = ["x.com", "t.me", "twitter.com"];
    if (NON_ARTICLE_DOMAINS.includes(domain)) {
        return res.status(422).json({
            error: "Unsupported domain",
            message: `${domain} does not serve standard article content.`,
        });
    }

    let page;
    try {
        const browser = await getBrowser();
        page = await browser.newPage();

        // Stealth: rotate user agent + set extra headers
        await page.setUserAgent(randomUserAgent());
        await page.setExtraHTTPHeaders({
            "Accept-Language": "en-US,en;q=0.9",
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        });
        await page.setViewport({ width: 1280, height: 800 });
        await page.setDefaultNavigationTimeout(NAVIGATION_TIMEOUT);

        // Navigate
        const waitStrategy = isJSHeavy(url) ? "networkidle2" : "domcontentloaded";
        try {
            await page.goto(url, { waitUntil: waitStrategy });
        } catch (err) {
            throw new Error(`Navigation failed: ${err.message}`);
        }

        // Dismiss cookie banners
        await dismissCookieBanners(page);

        // For JS-heavy sites, wait a bit for content to render
        if (isJSHeavy(url)) {
            await new Promise((r) => setTimeout(r, CONTENT_WAIT_TIMEOUT));
        }

        let html = await page.content();

        // Clean ads, interstitials, and inline ad scripts before extraction
        html = cleanAdContent(html);

        // ── Extraction Strategy ──────────────────────────────────────────────────
        let title = "";
        let content_html = "";
        let content_text = "";
        let extraction_method = "readability";

        // 1. Try site-specific selector first (more accurate for known sites)
        const siteSelector = !force_readability ? getSiteSelector(url) : null;
        if (siteSelector) {
            const selectorContent = await extractWithSelector(page, siteSelector);
            if (selectorContent && selectorContent.length > 200) {
                const cleaned = cleanAdContent(selectorContent);
                title = await page.title();
                content_html = cleaned;
                content_text = new JSDOM(cleaned).window.document.body.textContent.trim();
                extraction_method = "site_selector";
            }
        }

        // 2. Fallback to Readability
        if (!content_html) {
            const article = await extractArticle(html, url);
            if (!article) {
                throw new Error("Could not extract article content from this page.");
            }
            title = article.title || "";
            content_html = article.content || "";
            content_text = article.textContent?.trim() || "";
            extraction_method = "readability";
        }

        // 3. Meta fallback for title
        if (!title) {
            title = await page.$eval('meta[property="og:title"]', (el) => el.content).catch(() => "");
        }

        return res.json({
            url,
            domain,
            title,
            content_html,
            content_text,
            extraction_method,
            word_count: content_text.split(/\s+/).filter(Boolean).length,
        });

    } catch (err) {
        console.error(`[/scrape] Error for ${url}:`, err.message);
        return res.status(500).json({
            error: "Scrape failed",
            url,
            message: err.message,
        });
    } finally {
        if (page) {
            try { await page.close(); } catch {}
        }
    }
});

// ─── Health Check ─────────────────────────────────────────────────────────────

app.get("/health", (req, res) => res.json({ status: "ok" }));

// ─── Graceful Shutdown ────────────────────────────────────────────────────────

process.on("SIGTERM", async () => {
    if (browserInstance) await browserInstance.close();
    process.exit(0);
});

app.post("/pdf", async (req, res) => {
    const { title, content_html, filename } = req.body;

    if (!title || !content_html || !filename) {
        return res.status(400).json({
            error: "Missing required fields: title, content_html, filename"
        });
    }

    let browser;
    try {
        browser = await puppeteer.launch({
            args: ["--no-sandbox", "--disable-setuid-sandbox"]
        });

        let page;
        try {
            page = await browser.newPage();
        } catch (err) {
            throw new Error(`Failed to open browser page: ${err.message}`);
        }

        const html = `
        <html>
        <head>
        <meta charset="utf-8">
        <style>
        body { font-family: Arial, sans-serif; padding: 40px; line-height: 1.6; }
        h1 { font-size: 28px; }
        img, iframe { max-width: 100%; }
        </style>
        </head>
        <body>
        <h1>${title}</h1>
        ${content_html}
        </body>
        </html>
        `;

        try {
            await page.setContent(html, { waitUntil: "networkidle0" });
        } catch (err) {
            throw new Error(`Failed to set page content: ${err.message}`);
        }

        let pdfBuffer;
        try {
            pdfBuffer = await page.pdf({ format: "A4", printBackground: true });
        } catch (err) {
            throw new Error(`Failed to generate PDF: ${err.message}`);
        }

        const safeFilename = encodeURIComponent(filename);
        res.set({
            "Content-Type": "application/pdf",
            "Content-Disposition": `attachment; filename="${filename}.pdf"; filename*=UTF-8''${safeFilename}.pdf`,
        });
        res.send(pdfBuffer);

    } catch (err) {
        console.error("[/pdf] Error:", err.message);
        res.status(500).json({
            error: "PDF generation failed",
            message: err.message
        });
    } finally {
        if (browser) {
            try {
                await browser.close();
            } catch (err) {
                console.error("[/pdf] Failed to close browser:", err.message);
            }
        }
    }
});

app.post("/docx", async (req, res) => {
    const { title, content_html, filename } = req.body;

    if (!title || !content_html || !filename) {
        return res.status(400).json({
            error: "Missing required fields: title, content_html, filename"
        });
    }

    try {
        const html = `
        <html>
        <head>
        <meta charset="utf-8">
        </head>
        <body>
        <h1>${title}</h1>
        ${content_html}
        </body>
        </html>
        `;

        let docxBuffer;
        try {
            docxBuffer = await HTMLtoDOCX(html, null, {
                table: { row: { cantSplit: true } },
                footer: true,
                pageNumber: true,
            });
        } catch (err) {
            throw new Error(`Failed to generate DOCX: ${err.message}`);
        }

        const safeFilename = encodeURIComponent(filename);
        res.set({
            "Content-Type": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            "Content-Disposition": `attachment; filename="${filename}.docx"; filename*=UTF-8''${safeFilename}.docx`,
        });
        res.send(docxBuffer);

    } catch (err) {
        console.error("[/docx] Error:", err.message);
        res.status(500).json({
            error: "DOCX generation failed",
            message: err.message
        });
    }
});

app.listen(3000, () => console.log("Puppeteer API running on port 3000"));
