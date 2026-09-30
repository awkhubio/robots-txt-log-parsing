# robots_summary.awk -- who requested /robots.txt
#   awk -f robots_summary.awk access_log
#   fgrep robots.txt access_log | awk -f robots_summary.awk
#   Design: awkhub.io
#   Code: Grok
#   Date: 2026

function classify(ua) {
    if (ua ~ /OAI-SearchBot/)              return "OAI-SearchBot (OpenAI)"
    if (ua ~ /GPTBot/)                     return "GPTBot (OpenAI)"
    if (ua ~ /Googlebot/)                  return "Googlebot (Google)"
    if (ua ~ /facebookexternalhit/)        return "facebookexternalhit (Meta)"
    if (ua ~ /AhrefsBot/)                  return "AhrefsBot (Ahrefs)"
    if (ua ~ /Amazonbot/)                  return "Amazonbot (Amazon)"
    if (ua ~ /DuckAssistBot|DuckDuckBot/)  return "DuckAssistBot (DuckDuckGo)"
    if (ua ~ /PetalBot/)                   return "PetalBot (Huawei)"
    if (ua ~ /IDProspects/)                return "IDProspects (In-Depth)"
    if (ua ~ /wpbot/)                      return "wpbot"
    if (ua ~ /Edg\//)                      return "browser-like (Edge UA)"
    if (ua ~ /Chrome\//)                   return "browser-like (Chrome UA)"
    if (ua ~ /[Bb]ot|[Cc]rawler|[Ss]pider/) return "other-bot: " ua
    if (ua == "" || ua == "-")             return "empty-UA"
    return "unknown: " ua
}

{
    nq = split($0, q, "\"")
    if (nq < 6) next

    request = q[2]
    ua      = q[6]

    if (request !~ /\/robots\.txt([ ?]|$)/) next

    ip = $1
    label = classify(ua)
    hits[label]++
    if (!seen[label SUBSEP ip]++) ips[label]++
    total++
}

END {
    if (!total) {
        print "No /robots.txt requests found."
        exit 0
    }

    printf "%-32s %6s %8s\n", "WHO", "HITS", "UNIQ_IP"
    printf "%-32s %6s %8s\n", "--------------------------------", "------", "--------"

    nwho = 0
    for (lab in hits) {
        nwho++
        sortkey[nwho] = sprintf("%09d\t%s", 100000000 - hits[lab], lab)
    }
    for (i = 2; i <= nwho; i++) {
        tmp = sortkey[i]
        j = i - 1
        while (j >= 1 && sortkey[j] > tmp) {
            sortkey[j + 1] = sortkey[j]
            j--
        }
        sortkey[j + 1] = tmp
    }
    for (i = 1; i <= nwho; i++) {
        split(sortkey[i], parts, "\t")
        lab = parts[2]
        printf "%-32s %6d %8d\n", lab, hits[lab], ips[lab] + 0
    }
    printf "%-32s %6s %8s\n", "--------------------------------", "------", "--------"
    printf "%-32s %6d\n", "TOTAL /robots.txt hits", total
}
