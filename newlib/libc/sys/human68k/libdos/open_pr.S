| int _dos_open_pr (const char *, int, int, int, int, int, struct _dos_prcctrl *, long);
.text
.even
.global _dos_open_pr
.type _dos_open_pr,@function
_dos_open_pr:
	move.l	%sp@(32), %sp@- |4, push long sleep_time
    move.l	%sp@(32), %sp@- |4, push struct _dos_prcctrl* buff,
    move.l	%sp@(32), %sp@- |4, push int pc
    move.w	%sp@(32), %sp@- |2, push int sr

	move.l	%sp@(30), %sp@- |4, push int ssp
	move.l	%sp@(30), %sp@- |4, push int usp
	move.w	%sp@(30), %sp@- |2, push int counter
	move.l	%sp@(28), %sp@- |4, const char *name
	.short	0xfff8
	lea	%sp@(28), %sp
	rts
