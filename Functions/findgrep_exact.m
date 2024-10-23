function X=findgrep_eact(LIST,PATTERN)
LIST=lower(LIST);
PATTERN=lower(PATTERN);
X=strmatch(PATTERN,LIST,'exact');
