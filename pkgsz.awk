# pkgsz.awk
BEGIN {
	tot = 0
}
{
 tot += $1
} 
END {
 print done
 printf("%lu\n", tot);
}
