#include <stdio.h>
#include <string.h>

// Buffer to store filename
char filename[200];
// Buffer to store output filename
char outputFile[200];

// Buffer to store contents of input file
//char  lines[1000][100];

// Temp buffer to store binary conversion
char bin[9];
// Debug flag
int debug = 0;

// Input file handle
FILE * in;
// Output file handle
FILE * out;

// Arrays to hold stripped instructions
char* strpIns;
char* strpArgs[4];


//Function declerations
int fileLen(FILE * fp);
const char *getFilenameExt(const char *filename);
void getOutputFile(const char *filename,char* outputFilename);
void encode(char *args[],char[9]);
void stripInstruction(char** arg,char* inputStr);

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
		if (strcmp("txt", getFilenameExt(argv[1]))){
			printf("%s\n", argv[1]);
			printf("Invalid file extension %s\n", getFilenameExt(argv[1]));
			printf("All files must have file extension of .txt\n");
			return;
		}
		// Get the filename for the output file
		getOutputFile(argv[1], outputFile);
		// Open the input file for reading
		in = fopen(argv[1], "r");
		int len = fileLen(in);
		// Close the file so we can reopen it later to read it properly
		fclose(in);

		char lines[len][200];

		printf("Compiling %d lines\n", len);
		
		// Open input and output file	
		in = fopen(argv[1], "r");
		out = fopen(outputFile, "w");
		for (int i = 0; i < len; i++) {
			
			// Read a line from the input file
			fgets(lines[i], sizeof(lines[0]), in);	
			// Strip the newline character
			//strtok(lines[i], "\n");
			
			// If it is not an empty string
			if (strlen(lines[i]) > 2) {

				// Debugging info
				if (debug) {
					printf("Line %3d : ", i + 1);
				}
				// Strip any comments from the code
				for (int c = 0; c < sizeof(lines[i]); c++) {
					if (lines[i][c] == '#'|| lines[i][c]=='\r') {
						lines[i][c] = '\0';
					}
					if (lines[i][c] == '\t') {
						lines[i][c] = ' ';
					}
				}
				if (debug) {
					printf("%s\t\t", lines[i]);
					if (lines[i][0]=='d'||lines[i][0]=='c')
						printf("\t");
				}
				// Parse string and seperate instructions
				stripInstruction(strpArgs,lines[i]);
				// More debugging info
				// Convert to binary format
				encode(strpArgs,bin);
				// Write to output file
				fprintf(out, bin,9);
				// Uncomment this line for human read-ability
				//fprintf(out, "\n");
				// Print out encoded line
				if (debug) {
					//printf("\n");
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
void encode(char *args[], char out[9]){
		
		//Set up variables		
		char cmdi[4];	//command in
		char cmdo[2];	//command out

		char rg0i[3];	//destination register in
		char rg0o[3];	//destination register out
		
		char rg1i[3];	//source register in
		char rg1o[3];	//source register out
		
		char rg2i[3];	//target register in
		char rg2o[3];	//target register out
		
		char imm[5];	//immediate value
		strcpy(imm,"none"); //initialize to "none"

		char jmpi[2];	//jump amount in
		char jmpo[3];	//jump amount out
		
		char instructionOut[9];		//binary instruction out
		instructionOut[0] = '\0';	//start with null
		
		strcpy(cmdi, args[0]);		//pull instruction into command in
		cmdi[3] = '\0';

		strcpy(rg0i, args[1]);		//pull destination register into destination register in
		rg0i[2] = '\0';

		//Identify the instruction, determine the binary code for it, and store that in command out.
		if ((strcmp(cmdi, "lod") == 0)){
			strcpy(cmdo,"00");
		}//if
		
		else if((strcmp(cmdi, "add") == 0)){
			strcpy(cmdo,"01");
		}//else if
		
		else if((strcmp(cmdi, "sub") == 0)){
			strcpy(cmdo,"10");
		}//else if
		
		else if((strcmp(cmdi, "dsp") == 0)){
			strcpy(cmdo,"11");
		}//else if
		
		else if((strcmp(cmdi, "cmp") == 0)){
			strcpy(cmdo,"11");
		}//else if
		
		//Identify destination register and determine the binary for it
		if((strcmp(rg0i,"r0") == 0)){
			strcpy(rg0o,"00");
		}//if

		else if((strcmp(rg0i,"r1") == 0)){
			strcpy(rg0o,"01");
		}//if

		else if((strcmp(rg0i,"r2") == 0)){
			strcpy(rg0o,"10");
		}//if	
		
		else if((strcmp(rg0i,"r3") == 0)){
			strcpy(rg0o,"11");
		}//if
		
		
		//From here on out we are decoding/encoding the instruction based on which one it is.
		
		//Starting with the load immediate.
		if ((strcmp(cmdi,"lod") == 0)){			//copy the binary immediate from the input string to the immediate variable.
			strcpy(imm, args[2]);		
			imm[5] = '\0';
		
			strcat(instructionOut,cmdo);		//cat the command out binary to the instruction out.
			strcat(instructionOut,rg0o);		//cat the destination register to the instruction out.
			strcat(instructionOut,imm);			//cat the immediate value to the instruction out.
		
			instructionOut[8] = '\0';
		}//if load case
		
		//Now we handle the add and sub instructions.
		else if ((strcmp(cmdi, "add") == 0) || (strcmp(cmdi, "sub") == 0)){ 	//add or sub
			
			strcpy(rg1i, args[2]);		//pull source register info from input string to source register in.
			rg1i[2] = '\0';
			
			strcpy(rg2i, args[3]);		//pull target register info from input string to source register in.
			rg2i[2] = '\0';
			
			//Identify source register and store binary representation in source register out.
			if((strcmp(rg1i,"r0") == 0)){
				strcpy(rg1o,"00");
			}//if

			else if((strcmp(rg1i,"r1") == 0)){
				strcpy(rg1o,"01");
			}//if

			else if((strcmp(rg1i,"r2") == 0)){
				strcpy(rg1o,"10");
			}//if	
		
			else if((strcmp(rg1i,"r3") == 0)){
				strcpy(rg1o,"11");
			}//if

			//Identify target register and store binary representation in target register out.
			
			if((strcmp(rg2i,"r0") == 0)){
				strcpy(rg2o,"00");
			}//if

			else if((strcmp(rg2i,"r1") == 0)){
				strcpy(rg2o,"01");
			}//else if

			else if((strcmp(rg2i,"r2") == 0)){
				strcpy(rg2o,"10");
			}//else if	
		
			else if((strcmp(rg2i,"r3") == 0)){
				strcpy(rg2o,"11");
			}//else if
			
			strcat(instructionOut,cmdo);
			strcat(instructionOut,rg0o);
			strcat(instructionOut,rg1o);
			strcat(instructionOut,rg2o);		
		
		}//else if add or sub
		
		else if ((strcmp(cmdi, "cmp") == 0)){ 	//cmp
			strcpy(rg1i, args[2]);
			rg1i[2] = '\0';

			//read in 2nd register
			
			if((strcmp(rg1i,"r0") == 0)){
				strcpy(rg1o,"00");
			}//if

			else if((strcmp(rg1i,"r1") == 0)){
				strcpy(rg1o,"01");
			}//if

			else if((strcmp(rg1i,"r2") == 0)){
				strcpy(rg1o,"10");
			}//if	
		
			else if((strcmp(rg1i,"r3") == 0)){
				strcpy(rg1o,"11");
			}//if

			
			strcpy(jmpi, args[3]);
			jmpi[1] = '\0';
			
			//checking for number of lines to skip
			if ((strcmp(jmpi,"1") == 0)){
				strcpy(jmpo,"01");
			}//if
			
			else if((strcmp(jmpi,"2") == 0)){
				strcpy(jmpo,"10");
			}//else if
			
			strcat(instructionOut,cmdo);
			strcat(instructionOut,rg0o);
			strcat(instructionOut,rg1o);
			strcat(instructionOut,jmpo);		
			
		}//else if cmp
		
		
		else if ((strcmp(cmdi, "dsp") == 0)){ 	//dsp
			strcat(instructionOut,cmdo);
			strcat(instructionOut,rg0o);
			strcat(instructionOut,"0000");		
			
		}//else if dsp
		
		/*
		printf("Command in: %s\n",cmdi);
		printf("Register in: %s\n\n", rg0i);

		printf("Command out: %s\n",cmdo);
		printf("Register out: %s\n\n", rg0o);

		printf("imm is: %s\n\n", imm);
		*/
		for (int i =0;i<9;i++){
			out[i]=instructionOut[i];
		}
		if (debug){
			printf("Final binary is: %s\n",instructionOut);
		}
		
}//decode()


void stripInstruction(char** arg, char* inputStr){
		  char * instr;
		  int index = 0;
		  
		  instr = strtok (inputStr," ,.-");
		  
		  while (instr != NULL){
			arg[index] = instr;
			instr = strtok (NULL, " ,.-");
			index++;
		  }//while
		  
		  while (index < 4){
				arg[index] = " ";
				index++;
		  }//while

}//strip



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