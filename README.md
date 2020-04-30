# butterfree

Upload files to ferrothorn

## Project Goals

This is a tool to upload arbitrary files to a [ferrothorn](https://github.com/gastrodon/ferrothorn) server. Because ferrothorn has no listing features (ie it cannot tell you _what_ is uploaded), this tool should also keep track of what it uploaded, and the url pointing to that file on the server. Ferrothorn uploading is fairly simple, it only requires an `Authorization` header to be present if the server is configured to require one
