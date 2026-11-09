;EverDrive X OS mode pages (see PAGE in macros.asm and pages.link): every page has a fragment, and
;$BD00-$BFFF are the EverDrive's registers and window in all of them, so a page holds PAGE_SIZE bytes
FOR N, FIRST_PAGE, LAST_PAGE+1
  PAGE N
  END_PAGE
SECTION "Page {d:N} regs", SRAM, BANK[N]
  DS $2000-PAGE_SIZE
ENDR
