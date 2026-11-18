; FOR and INCBIN
SECTION "Loops", ROM0[$150]
FOR V, 3
  db V
ENDR
  db V
FOR V, 10, 4, -2
  db V
ENDR
  db V
FOR W, 5, 5
  db 99
ENDR
  db W
FOR X, 1, 8, 3
  db X * 2
  FOR Y, 2
    db X + Y, {d:Y}
  ENDR
ENDR
Data:
  INCBIN "lib/data.bin"
  INCBIN "lib/data.bin", 7
  INCBIN "././lib/data.bin", 2, 3
.end
  db .end - Data
; INCBIN copies runs: misaligned against the file's 256-byte halves and the image's blocks,
; and one that ends at the bank's last byte
SECTION "Runs", ROMX
  ds 37, $AA
  INCBIN "lib/big.bin", 3
  INCBIN "lib/big.bin", 1000, 300
  INCBIN "lib/big.bin", 1499
SECTION "Tail", ROMX[$7F80]
  INCBIN "lib/big.bin", 100, $80
