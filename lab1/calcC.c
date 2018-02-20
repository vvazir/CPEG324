#include <stdio.h>
#include <string.h>

char* fileName[100];
char  lines[100][16];
char buf[100];
int bugsize = 100;
FILE * fp;

int fileLen(FILE * fp);
const char *get_filename_ext(const char *filename);

void main(int argc, char *argv[]) {
	if (argc == 1) {
		printf("Invalid number of arguments\n");
	}
	else {
		printf("%s\n", get_filename_ext(argv[1]));
		fp = fopen(argv[1], "r");
		int len = fileLen(fp);
		printf("Number of lines: %d\n", len);
		//char* lines[len];
		fp = fopen(argv[1], "r");
		for (int i = 0; i < len; i++) {
			printf("Line: %d\n", i+1);
			fgets(lines[i], sizeof(lines[0]), fp);
			strtok(lines[i], "\n");
			printf("%s\n",lines[i]);
		}
		fclose(fp);
	}
	
	printf("Hello World\n");
	
}

const char *get_filename_ext(const char *filename) {
	const char *dot = strrchr(filename, '.');
	if (!dot || dot == filename) return "";
	return dot + 1;
}

int fileLen(FILE * fp) {
	int lines = 0;
	char ch;
	if (fp == NULL) {
		return 0;
	}
	lines++;
	while (!feof(fp))
	{
		ch = fgetc(fp);
		if (ch == '\n')
		{
			lines++;
		}
	}
	fclose(fp);
	return lines;
}