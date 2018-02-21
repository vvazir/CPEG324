#include <stdio.h>
#include <string.h>

// Buffer to store filename
char fileName[200];
// Buffer to store output filename
char outputFile[200];

// Buffer to store contents of input file
char  lines[1000][100];

// Temp buffer to store binary conversion
char bin[9];
// Debug flag
int debug = 0;

// Input file handle
FILE * in;
// Output file handle
FILE * out;

//Function declerations
int fileLen(FILE * fp);
const char *getFilenameExt(const char *filename);
void encode(char *line,char * output);
void getOutputFile(const char *filename,char* outputFilename);

void main(int argc, char *argv[]) {
	if (argc != 2 && argc !=3 ) {
		printf("Invalid number of arguments\n");
		printf("Proper usage:\n");
		printf("calcC <filename>\n [-v]");
		printf("Will output a file with the same filename and extension jv\n");
		printf("add the flag -v for verbose output \n");
		return;
	}
	else {
		if (argc == 3) {
			// Verbose output
			if (!strcmp(argv[2], "-v")) {
				debug = 1;
			}
		}
		// Check for proper file extension
		if (strcmp("vj", getFilenameExt(argv[1]))){
			printf("%s\n", argv[1]);
			printf("Invalid file extension %s\n", getFilenameExt(argv[1]));
			printf("All files must have file extension of .vj\n");
			return;
		}
		// Get the filename for the output file
		getOutputFile(argv[1], outputFile);
		// Open the input file for reading
		in = fopen(argv[1], "r");
		int len = fileLen(in);
		// Close the file so we can reopen it later to read it properly
		fclose(in);

		if (len > 1000) {
			printf("Input file is to big, max 1000 allowed\n");
			return;
		}

		printf("Compiling %d lines\n", len);
		
		// Open input and output file	
		in = fopen(argv[1], "r");
		out = fopen(outputFile, "w");
		for (int i = 0; i < len; i++) {
			
			// Read a line from the input file
			fgets(lines[i], sizeof(lines[0]), in);
			
			// Strip the newline character
			strtok(lines[i], "\n");
			
			// If it is not an empty string
			if (strlen(lines[i]) > 1) {

				// Debugging info
				if (debug) {
					printf("Line %d:\n", i + 1);
				}

				// Strip any comments from the code
				for (int c = 0; c < sizeof(lines[i]); c++) {
					if (lines[i][c] == '#') {
						lines[i][c] = '\0';
					}
				}
				// More debugging info
				if (debug) {
					printf("%s\n", lines[i]);
				}

				// Convert to binary format
				encode(lines[i],bin);
				// Write to output file
				fprintf(out, bin,9);
				// Uncomment this line for human read-ability
				fprintf(out, "\n");
				// Print out encoded line
				if (debug) {
					printf("%s\n\n", lines[i]);
				}
			}
		}

		
		printf("Compiled successfully ");
		printf("output is located in %s\n", outputFile);
		// Close files
		fclose(out);
		fclose(in);
		return;
	}
	// The code should never reach here, but just incase, say something went wrong
	printf("Error while compiling\n");
}

void encode(char* line, char * output) {
	/*
		This function consumes a string of commands and produces a
		binary representation of the string in the calc ISA
		parameters:
			line - a char array containg calc ISA commands
			output - a char array to store the binary representation of the command
		returns:
	*/
	line[1] = '!';
	for (int i = 0; i < 8; i++) {
		output[i] = line[i];
	}
	output[8] = '\0';
	return;
}

const char *getFilenameExt(const char *filename) {
	/*
		This function consumes a file name and extracts the file extension
		parameters:
			filename - a char array containing the filename
		returns:
			ext - a char array containing the file extension
	*/
	const char *ext = strrchr(filename, '.');
	// If there is no file extension, return an empty string
	if (!ext || ext == filename) {
		return "";
	}
	// Return the file exension
	return ext + 1;
}
void getOutputFile(const char *filename,char *outputFilename) {
	/*
		This function consumes a filename and produces a new filename with the extension
		changed to .jv
		parameters:
			filename - a char array containing the filename
			outputFilename - the filename with the changed extension
		returns:		
	*/
	// If it is an empty filename, exit
	if (strlen(filename) == 0) {
		return;
	} 
	// Find the last file extension, and replace it with .jv
	for (int i = strlen(filename)-1; i >=0; i--) {
		if (filename[i] == '.') {
			for (int c = 0; c <= i; c++) {
				outputFilename[c] = filename[c];
			}
			outputFilename[i + 1] = 'j';
			outputFilename[i + 2] = 'v';
			break;
		}
	}
	return;
}


int fileLen(FILE * fp) {
	/*
		Given a file fp, find the number of lines in the file
		Parameters:
			fp - a file handle
		returns:
			lines - number of lines in the file
	*/
	int lines = 0;
	char ch;
	// If there is an invalid file handle, return 0
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
	return lines;
}