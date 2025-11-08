# Invoke-MailHeaderForensics

Searches for `InternetHeader.txt` in `pffexport` results an generates a csv with the following informations for each mail:

Date,From,To,Subject,ReturnPath,ReplyTo

## Prerequisites

Make sure to parse your OST/PST file with `pffexport`, which is already installed on [SIFT](https://www.sans.org/tools/sift-workstation).

Example:

```
pffexport -t [path to base directory] -l [path to pffexport log] -m [export mode] -v path/to/file.ost

-t:  specify the basename of the target directory to export to
     (default is the source filename) pffexport will add the
     following suffixes to the basename: .export, .orphans,
	 .recovered

-l:  logs information about the exported items

-m:  export mode, option: all, debug, items (default), recovered.
     'all' exports the (allocated) items, orphan and recovered
	 items. 'debug' exports all the (allocated) items, also those
	 outside the the root folder. 'items' exports the (allocated)
	 items. 'recovered' exports the orphan and recovered items.

-v: verbose output to stderr
```

You can use it also on any other folder structure. The only requirement is that there is a separate header file for each email. You just need to provide the correct name of the file for the `HeaderFileName` option.

## Usage

`.\Invoke-MailHeaderForensics.ps1 -Path [STRING] -Output [STRING] -FileName [STRING] -HeaderFileName [STRING]`

| Option         | Type   | Default                       | Description                                                      |
| -------------- | ------ | ----------------------------- | ---------------------------------------------------------------- |
| Path           | String | -                             | Path to folder structure where -HeaderFileName files are located |
| Output         | String | .\results\mailheaderforensics | Path to write timeline output                                    |
| FileName       | String | available-mails.csv           | Name of the result file                                          |
| HeaderFileName | String | InternetHeaders.txt           | The name of the file in which the mail header data is located    |
