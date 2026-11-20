param(
    [string]$OutputDirectory = "$HOME\ps-transcript"
)

Start-Transcript -OutputDirectory $OutputDirectory -IncludeInvocationHeader -Append -NoClobber