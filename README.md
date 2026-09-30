# robots-txt-log-parsing
AWK script that parses web server access logs and counts who requested /robots.txt, with unique IP totals.


# robots.txt log parsing

Count which clients requested `/robots.txt` in a Combined Log Format access log.

## Usage

```sh
awk -f robots_summary.awk access_log
