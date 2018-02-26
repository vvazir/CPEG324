#include <stdio.h>
#include <string.h>

#define lod "00"

// Input file handle
FILE * in;

// Debug flag
int debug = 0;

//Function declerations
int fileLen(char* filename);
const char *getFilenameExt(const char *filename);
void readFile(char* filename, char [][8], int len);
void decode(char[][8], char[][16],int len);
int getReg(char[2]);

void main(int argc, char *argv[]) {
	if (argc != 2 && argc !=3 ) {
		printf("Invalid number of arguments\n");
		printf("Proper usage:\n");
		printf("calcC <filename>\n [-v]");
		printf("Will output a file with the same file name and extension jv\n");
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
		// Check for valid file name
		char * filename = argv[1];
		if (debug){
			printf("Opening file: %s\n",filename);
		}
		in = fopen(filename,"r");
		if (in==NULL){
			printf("Invalid file name %s\n",filename);
			return;
		}
		fclose(in);
		// Check for valid extension
		const char * ext = getFilenameExt(filename);
		if (strcmp(ext,"jv")){
			printf("Invalid file extension %s\n",ext);
			return;
		}
		// Get number of instructions
		int instructions = fileLen(filename);
		if (debug){
			printf("There are %d instructions in the file %s\n",instructions,filename);
		}
		char bitList[instructions][8];
		char insList[instructions][16];
		// Get instructions
		if (debug){
			printf("Reading instructions from file\n");
		}
		readFile(filename,bitList,instructions);
		// Decode instructions
		decode(bitList,insList,instructions);
		// If debugging, print out instructions read
		if (debug){
			printf("line#:\t:Binary:\tdecoded\n");
			for (int i = 0;i<instructions;i++){
				printf("ins %d:\t",i+1);
				for(int c=0;c<8;c++){
					printf("%c",bitList[i][c]);
				}
				printf("\n");
			}
		}

	}
}
void decode(char bitList[][8],char insList[][16],int len){
	char opCode[2];
	char op[4];
	char reg1[2];
	char reg2[2];
	char reg3[2];
	char imm[4];
	char extra[2];
	
	char out[16];

	for (int ins=0;ins<len;ins++){

		opCode[0] = bitList[ins][0];
		opCode[1] = bitList[ins][1];

		reg1[0] = bitList[ins][2];
		reg1[1] = bitList[ins][3];
		
		reg2[0] = bitList[ins][4];
		reg2[1] = bitList[ins][5];
		
		reg3[0] = bitList[ins][6];
		reg3[1] = bitList[ins][7];
		
		imm[0] = bitList[ins][4];
		imm[1] = bitList[ins][5];
		imm[2] = bitList[ins][6];
		imm[3] = bitList[ins][7];
		
		extra[0] = bitList[ins][6];
		extra[1] = bitList[ins][7];
		
		

		if (!strcmp(opCode,"00")){
			strncpy(op,"lod ",4);		
		}
		else if (!strcmp(opCode,"01")){
			strncpy(op,"add ",4);	
		}
		else if (!strcmp(opCode,"10")){
			strncpy(op,"sub ",4);	
		}
		else if (!strcmp(opCode,"11")){
			
			strncpy(op,"add ",4);	
		}
		if (getReg(reg1) ||getReg(reg2)||getReg(reg3)){
			return;
		}

	}

}
int getReg(char reg[2]){
		if (!strcmp(reg,"00")){
			strncpy(reg,"r0",2);
		}
		else if (!strcmp(reg,"01")){
			strncpy(reg,"r1",2);
		}
		else if (!strcmp(reg,"10")){
			strncpy(reg,"r2",2);
		}
		else if (!strcmp(reg,"11")){
			strncpy(reg,"r3",2);
		}
		else{
			printf("Invalid reg number %c%c",reg[0],reg[1]);
			return 0;
		}
		return 1;
}
void readFile(char* filename, char bitList[][8],int len){
	FILE * fp = fopen(filename,"r");
	char bit;
	for (int ins = 0;ins<len;ins++){
		for (int pos = 0;pos<8;pos++){
			bit = fgetc(fp);
			if (bit != '\0')
			{
				bitList[ins][pos]=bit;
			}
		}
	}
	fclose(fp);
	return;
}

int fileLen(char* filename) {
	/*
		Given a file, find the length of the file in 8 bit segments
		Parameters:
			char* - a file name
		returns:
			ins - number of instructions in the file
	*/
	int ins = 0;
	char ch;
	// If there is an invalid file handle, return 0
	FILE * fp = fopen(filename, "r");
	if (fp == NULL) {
		return 0;
	}
	int c = 0;
	while (!feof(fp))
	{
		ch = fgetc(fp);
		if (ch != '\0')
		{
			c++;
		}
		if (c==8){
			ins++;
			c=0;
		}
	}
	fclose(fp);
	return ins;
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