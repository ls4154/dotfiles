/*
 * Simple backlight controller for intel graphics
 * due to the xbacklight is not working with modesetting.
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

char * const path_br = "/sys/class/backlight/intel_backlight/brightness";
char * const path_max = "/sys/class/backlight/intel_backlight/max_brightness";

const char *help_msg =
"options\n"
"-c	check current brightness\n"
"-i	increase brightness\n"
"-d	decrease brightness\n"
"-s N	set brightness\n"
"-h	display this help\n";

void show_help(void)
{
	printf(help_msg);
}

int main(int argc, char **argv)
{
	int opt;
	int br_cur, br_max;
	FILE *fp;

	if ((fp = fopen(path_max, "r")) == NULL) {
		fprintf(stderr, "cannot open file\n");
		exit(EXIT_FAILURE);
	}
	fscanf(fp, "%d", &br_max);
	fclose(fp);

	if ((fp = fopen(path_br, "r")) == NULL) {
		fprintf(stderr, "cannot open file\n");
		exit(EXIT_FAILURE);
	}
	fscanf(fp, "%d", &br_cur);
	fclose(fp);

	while ((opt = getopt(argc, argv, "cids:h")) != -1) {
		switch (opt) {
			case 'c':
				goto PRINT;
			case 'i':
				br_cur += 500;
				break;
			case 'd':
				br_cur -= 500;
				break;
			case 's':
				br_cur = atoi(optarg);
				break;
			case 'h':
			default:
				show_help();
				exit(EXIT_SUCCESS);
		}
	}

	if (br_cur < 0)
		br_cur = 0;
	else if (br_cur > br_max)
		br_cur = br_max;

	if ((fp = fopen(path_br, "w")) == NULL) {
		fprintf(stderr, "cannot open file\n");
		exit(EXIT_FAILURE);
	}
	fprintf(fp, "%d", br_cur);
	fclose(fp);

PRINT:
	printf("Brightness : %d/%d\n", br_cur, br_max);
	exit(EXIT_SUCCESS);
}
