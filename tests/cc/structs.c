// structs, unions, nested members, arrays of structs, pointers to structs, struct copies
#include "check.h"
struct point { int x, y; };
struct rect { struct point a, b; unsigned char tag; };
union word { unsigned int w; unsigned char b[2]; };
typedef struct node { int value; struct node* next; } Node;
struct rect g = { { 1, 2 }, { 30, 40 }, 9 };
struct point pts[3] = { { 1, 1 }, { 2, 4 }, { 3, 9 } };
int area(const struct rect* r) { return (r->b.x - r->a.x) * (r->b.y - r->a.y); }
int total(Node* n) { int s = 0; for (; n; n = n->next) s += n->value; return s; }
void move(struct point* p, int dx) { p->x += dx; p->y++; }
int main(void) {
  struct rect r;
  struct point p = { 5, 6 }, q;
  union word u;
  Node n3 = { 3, 0 }, n2 = { 2, &n3 }, n1 = { 1, &n2 };
  struct point* pp = pts;
  r.a.x = 0; r.a.y = 0; r.b.x = 4; r.b.y = 5; r.tag = 1;
  CHECK(area(&r) == 20); CHECK(area(&g) == 29 * 38); CHECK(g.tag == 9);
  CHECK(sizeof(struct rect) == 9); CHECK(sizeof(union word) == 2); CHECK(sizeof(Node) == 4);
  u.w = 0x1234; CHECK(u.b[0] == 0x34 && u.b[1] == 0x12);
  CHECK(total(&n1) == 6);
  q = p; CHECK(q.x == 5 && q.y == 6);
  p.x = 9; CHECK(q.x == 5);
  move(&q, 10); CHECK(q.x == 15 && q.y == 7);
  CHECK(pts[2].y == 9); CHECK((pp + 1)->y == 4); pp++; CHECK(pp->x == 2);
  CHECK(&pts[2] - &pts[0] == 2);
  g.b = p; CHECK(g.b.x == 9 && g.b.y == 6 && g.tag == 9);
  r = g; CHECK(r.b.x == 9 && r.a.y == 2 && r.tag == 9);
  pts[1] = pts[2]; CHECK(pts[1].x == 3 && pts[1].y == 9);
  { struct { char c; long l; } s = { 'x', 100000l }; CHECK(s.l == 100000l && s.c == 'x'); }
  return 0;
}
