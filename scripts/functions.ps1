function formatPath($path) {
    return $path -replace '(\[|\])', '``$1'
}

function formatName($path) {
    return $path -replace '(\[|\])', '`$1'
}
