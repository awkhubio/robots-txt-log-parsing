# robots.txt log parsing

AWK script that reads a Combined Log Format access log and prints who
requested `/robots.txt`, with hit counts and unique IPs.

## Usage

    awk -f robots_summary.awk access_log

Or on a pre-filtered stream:

    fgrep robots.txt access_log | awk -f robots_summary.awk

## What it counts

Only the request itself:

    GET /robots.txt

`fgrep robots.txt` matches that string anywhere on the line, including
later sitemap probes whose Referer is `https://example.com/robots.txt`.
Those follow-up requests are ignored.

## Sample output

    WHO                                HITS  UNIQ_IP
    -------------------------------- ------ --------
    OAI-SearchBot (OpenAI)                6        2
    browser-like (Chrome UA)              6        6
    AhrefsBot (Ahrefs)                    5        5
    Googlebot (Google)                    5        4
    facebookexternalhit (Meta)            4        4
    browser-like (Edge UA)                3        2
    wpbot                                 2        1
    Amazonbot (Amazon)                    1        1
    DuckAssistBot (DuckDuckGo)            1        1
    IDProspects (In-Depth)                1        1
    PetalBot (Huawei)                     1        1
    -------------------------------- ------ --------
    TOTAL /robots.txt hits               35

## Requirements

POSIX `awk` or `mawk`. No GNU awk extensions (`asort`, etc.).

## Files

- `robots_summary.awk` is the parser
- Do not commit raw `access_log` files
