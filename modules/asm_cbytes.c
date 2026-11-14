// ASM.MOD: build.cache's byte work in assembly (asm_cache.h): SDCC's loops and longs are too big.
#include "asm_cache.h"

#ifndef HOST_TEST
static void CacheBytes(void) __naked {
  __asm
_CacheCopy4::
	ld	a, 4
	jr	CacheCopyN
_CacheCopy11::
	ld	a, 11
CacheCopyN:
	ld	h, b
	ld	l, c
CacheCopyLoop:
	push	af
	ld	a, [hl+]
	ld	[de], a
	inc	de
	pop	af
	dec	a
	jr	nz, CacheCopyLoop
	ret
_CacheCopyZ::
	ld	a, [bc]
	ld	[de], a
	inc	bc
	inc	de
	or	a, a
	jr	nz, _CacheCopyZ
	ret
_CacheTime::
	push	de
	ld	a, 1
	call	_ModStat
	pop	de
	ld	a, c
	sub	a, e
	ld	c, a
	ld	a, b
	sbc	a, d
	ld	b, a
	ld	hl, _card_frames
	ld	a, [hl]
	add	a, c
	ld	[hl+], a
	ld	a, [hl]
	adc	a, b
	ld	[hl+], a
	ld	a, [hl]
	adc	a, 0
	ld	[hl+], a
	ld	a, [hl]
	adc	a, 0
	ld	[hl], a
	ret
_CacheSame::
	ld	a, 4
	jr	CacheSameN
_CacheSame11::
	ld	a, 11
CacheSameN:
	ld	h, b
	ld	l, c
CacheSameLoop:
	push	af
	ld	a, [de]
	cp	a, [hl]
	jr	nz, CacheDiffer
	inc	de
	inc	hl
	pop	af
	dec	a
	jr	nz, CacheSameLoop
	ret
CacheDiffer:
	pop	af
	ld	a, 1
	ret
_CacheBlocks::
	ld	hl, _cache_size
	ld	a, [hl+]
	ld	d, a
	ld	a, [hl+]
	ld	e, a
	ld	b, [hl]
	srl	b
	ld	a, e
	rra
	ld	c, a
	ld	a, d
	jr	c, CacheRoundUp
	or	a, a
	ret	z
CacheRoundUp:
	inc	bc
	ret
_CacheName::
	ld	hl, _ident
	ld	b, a
	jr	CacheGet
_CacheRecord::
	ld	hl, _cache_rec
	ld	b, 17
CacheGet:
	push	hl
	push	bc
	push	de
	call	_CacheByte
	pop	de
	pop	bc
	pop	hl
	ld	[hl+], a
	inc	de
	dec	b
	jr	nz, CacheGet
	ret
_CacheSector::
	push	bc
	ld	h, d
	ld	l, e
	ld	a, [hl+]
	ld	c, a
	ld	a, [hl+]
	ld	b, a
	ld	a, [hl+]
	ld	e, a
	ld	d, [hl]
	call	_ModSector
	ret
  __endasm;
}
// cache_sec = the data sector + (cache_cl - 2) * the cluster size (a power of 2)
void Sector(void) __naked {
  __asm
	ld	hl, _cache_cl
	ld	de, _cache_sec
	ld	a, [hl+]
	sub	a, 2
	ld	[de], a
	inc	de
	ld	c, 3
.borrow:
	ld	a, [hl+]
	sbc	a, 0
	ld	[de], a
	inc	de
	dec	c
	jr	nz, .borrow
	ld	a, [_cache_head + 5]
.scale:
	srl	a
	jr	z, .add
	ld	hl, _cache_sec
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	jr	.scale
.add:
	ld	hl, _cache_head + 10
	ld	de, _cache_sec
	jr	CacheAdd
  __endasm;
}
// cache_fnew = the FAT sector holding cache_cl's entry, cache_at its place there
void FatPlace(void) __naked {
  __asm
	ld	hl, _cache_cl + 1
	ld	de, _cache_fnew
	ld	a, [hl+]
	ld	[de], a
	inc	de
	ld	a, [hl+]
	ld	[de], a
	inc	de
	ld	a, [hl]
	ld	[de], a
	inc	de
	xor	a, a
	ld	[de], a
	ld	a, [_cache_cl]
	ld	c, a
	ld	a, [_cache_head + 4]
	cp	a, 3
	jr	nz, .fat16
	ld	hl, _cache_fnew
	ld	a, c
	rla
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	ld	a, c
	and	a, 127
	ld	l, a
	ld	h, 0
	add	hl, hl
	add	hl, hl
	jr	.at
.fat16:
	ld	l, c
	ld	h, 0
	add	hl, hl
.at:
	ld	a, l
	ld	[_cache_at], a
	ld	a, h
	ld	[_cache_at + 1], a
	ld	hl, _cache_head + 6
	ld	de, _cache_fnew
	; fall through
; the 4 bytes at de += those at hl
CacheAdd:
	ld	c, 4
	and	a, a
.sum:
	ld	a, [de]
	adc	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	dec	c
	jr	nz, .sum
	ret
  __endasm;
}
// 1 if cache_cl isn't a data cluster (under 2, past the volume's, or the chain's end)
unsigned char Bad(void) __naked {
  __asm
	ld	hl, _cache_cl + 3
	ld	a, [hl-]
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	jr	nz, .big
	ld	a, [hl]
	cp	a, 2
	jr	c, .bad
.big:
	ld	hl, _cache_cl + 3
	ld	de, _cache_nfat + 3
	ld	c, 4
.compare:
	ld	a, [de]
	ld	b, a
	ld	a, [hl-]
	cp	a, b
	jr	c, .ok
	jr	nz, .bad
	dec	de
	dec	c
	jr	nz, .compare
.bad:
	ld	a, 1
	ret
.ok:
	xor	a, a
	ret
  __endasm;
}
void NextSector(void) __naked {
  __asm
	ld	hl, _cache_sec
	inc	[hl]
	ret	nz
	inc	hl
	inc	[hl]
	ret	nz
	inc	hl
	inc	[hl]
	ret	nz
	inc	hl
	inc	[hl]
	ret
  __endasm;
}

#endif
