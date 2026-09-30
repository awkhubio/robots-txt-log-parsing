# robots-txt-log-parsing
AWK script that parses web server access logs and counts who requested /robots.txt, with unique IP totals.


Count which clients requested `/robots.txt` in a Combined Log Format access log.

## Usage

```sh
awk -f robots_summary.awk access_log

Or on a pre-filtered stream:sh

fgrep robots.txt access_log | awk -f robots_summary.awk

What it countsOnly the request URI GET /robots.txt.fgrep robots.txt also matches later sitemap probes whose Referer is https://example.com/robots.txt. Those are ignored on purpose.

