#include <stdio.h>
#include <string.h>

// Data type
struct Ins {
	char op[4];
	char r1[3];
	char r2[3];
	char r3[3];
	char imm[5];
	char jmp[2];
};

// Input file handle
FILE * in;

// Debug flag
int debug = 0;

//Function declerations
int fileLen(char* filename);
const char *getFilenameExt(const char *filename);
void readFile(char* filename, char [][8], int len);
int decode(char[][8], struct Ins[],int len);
int getReg(char[2]);

void lod(struct Ins ins);
void add(struct Ins ins);
void sub(struct Ins ins);
void dsp(struct Ins ins);
int cmp(struct Ins ins);





int r0=0;
int r1=0;
int r2=0;
int r3=0;
int pc=0;


void main(int argc, char *argv[]) {
	if (argc != 2 && argc !=3 ) {
		printf("Invalid number of arguments\n");
		printf("Proper usage:\n");
		printf("calc <filename>\n [-v]");
		printf("Will read in a binary file and currently do nothing, use the verbose command for cool stuff jv\n");
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
		if (instructions<0){
			printf("Error please use the -v option for verbose logging\n");
			return;
		}
		if (debug){
			printf("There are %d instructions in the file %s\n",instructions,filename);
		}
		char bitList[instructions][8];
		struct Ins insList[instructions];
		// Get instructions
		if (debug){
			printf("Reading instructions from file\n");
		}
		readFile(filename,bitList,instructions);
		// Decode instructions
		if (decode(bitList,insList,instructions)){
			printf("Error invalid instructions in file\n");
			printf("Read error log for what caused the error\n");
			printf("Run the calc program with the -v option for verbose logging\n");
			printf("----------------------------------------------\n");
		}
		// If debugging, print out instructions read
		if (debug){
			printf("line#:\t|\t:Binary:    |    op  r1 r2 r3 imm\n");
			for (int i = 0;i<instructions;i++){
				printf("ins %d:\t|\t",i+1);
				for(int c=0;c<8;c++){
					printf("%c",bitList[i][c]);
				}
				printf("    |    %s",insList[i].op);
				printf(" %s", insList[i].r1);
				printf(" %s", insList[i].r2);
				printf(" %s", insList[i].r3);
				printf(" %s", insList[i].imm);
				printf(" %s", insList[i].jmp);


				printf("\n");
			}
		}

	}
}
int decode(char bitList[][8],struct Ins insList[],int len){
	
	const char space[2] = " \0";
	for (int ins=0;ins<len;ins++){
		char opCode[3] = "  \0";
		char op[4];
		char reg1[3] = "  \0";
		char reg2[3] = "  \0";
		char reg3[3] = "  \0";
		char imm[5] = "    \0";
		char extra[3] = "  \0";
		char jmp[2] = "0\0";
		strncpy(jmp," ",1);
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
		
		if (getReg(reg1)||getReg(reg2)||getReg(reg3)){
				return 1;
		}
		if (!strcmp(opCode,"00")){
			strncpy(op,"lod",3);
			
		}
		else if (!strcmp(opCode,"01")){
			strncpy(op,"add",3);
		}
		else if (!strcmp(opCode,"10")){
			strncpy(op,"sub",3);
		}
		else if (!strcmp(opCode,"11")){
			if (!strcmp(extra,"00")){
				strncpy(op,"dsp",3);
			}
			else if (!strcmp(extra,"01")){
				strncpy(op,"cmp",3);
				strncpy(jmp,"1",1);		
			}
			else if (!strcmp(extra,"10")){
				strncpy(op,"cmp",3);
				strncpy(jmp,"2",1);
			}
		}
		strncpy(insList[ins].op,op,4);
		strncpy(insList[ins].r1, reg1, 3);
		strncpy(insList[ins].r2, reg2, 3);
		strncpy(insList[ins].r3, reg3, 3);
		strncpy(insList[ins].imm, imm, 5);
		strncpy(insList[ins].jmp,jmp, 2);
		//strncpy(insList[ins],out,16);
	}
	return 0;
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
			printf("Invalid reg number %c%c\n",reg[0],reg[1]);
			return 1;
		}
		return 0;
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
	if (c!=1){
		printf("Missing binary characters, should have 8 digits, instead you have %d\n",c);
		return -1;
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