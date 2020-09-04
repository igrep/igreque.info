#!/bin/bash

set -eu

source qiita-access-token

metadata_re='^---
.+
---
'

multipost \
    --url-placeholder '^canonicalUrl:(.*)$' \
    `# ^ Get the URL on Qiita of the article. If the first captured group is blank or` \
    `#   just "qiita", the article is treated as not posted yet.` \
    \
    --title '^title:(.*)$' \
    `# ^ The first captured group is the title of the post.` \
    \
    --tags '^qiitaTags:(.*)$' \
    `# ^ The first captured group is the tags of the post.` \
    `#   NOTE: "tags" in Hakyll are separated by comma, so I specified it` \
    `#         in the separate field "qiita-tags".` \
    \
    --metadata "$metadata_re" \
    `# ^ Strip the matched area before posting the article.` \
    `#   NOTE: This regex is matched by block mode: '.' matches` \
    `#         any characters including newline characters.` \
    \
    --qiita-access-token "$QIITA_ACCESS_TOKEN" \
    \
    "$@"
