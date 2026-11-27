#ifndef FATPAK_UI_SCROLLBAR_H
#define FATPAK_UI_SCROLLBAR_H

// The scroll bar at 160x144 while the mouse pointer shows (src/ui/scrollbar.asm). A view claims it every frame
// it waits for keys: range = {position, the largest position}, a largest of 0 for nothing to scroll (no bar).
// KEY_SCROLL is the thumb dragged and let go: ScrollTo sets range[0] to where, of range[1].
extern void ScrollBar(const unsigned long* range);
extern void ScrollTo(unsigned long* range);
extern unsigned long scroll_range[2]; // the host's views' (WRAM0 is full)
extern void ScrollBarWord(unsigned int position, unsigned int largest); // ScrollBar's in scroll_range, 16 bit
extern unsigned int ScrollToWord(void); // ScrollTo's of scroll_range, its position

#endif
