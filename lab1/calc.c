#include <stdio.h>
#include <string.h>
#include <stdint.h>
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
int readFile(char* filename, char [][8], int len);
int decode(char[][8], struct Ins[],int len);
int getReg(char[2]);

void lod(struct Ins ins);
void add(struct Ins ins);
void sub(struct Ins ins);
void dsp(struct Ins ins);
int ipow(int base, int exp);
int cmp(struct Ins ins);


#define KNRM  "\x1B[0m"
#define KRED  "\x1B[31m"
#define KGRN  "\x1B[32m"
#define KYEL  "\x1B[33m"
#define KBLU  "\x1B[34m"
#define KMAG  "\x1B[35m"
#define KCYN  "\x1B[36m"
#define KWHT  "\x1B[37m"

#define eof '\0'
int8_t r0=0;
int8_t r1=0;
int8_t r2=0;
int8_t r3=0;
int pc=0;


void main(int argc, char *argv[]) {
	if (argc != 2 && argc !=3 ) {
		
		printf("%sInvalid number of arguments%s\n",KRED,KWHT);
		printf("Use the [-h] argument for help on proper usage\n"); 
		return;
	}
	else {
		if (argc == 2) {
			if (!strcmp(argv[1], "-h")) {
				printf("Proper usage:\n");
				printf("calc <filename> [-v]\n");
				printf("Will read in a binary file and currently do nothing, use the verbose command for cool stuff\n");
				printf("add the flag -v for verbose output \n");
				return;
			}
		}
		if (argc == 3) {
			// Verbose output
			if (!strcmp(argv[2], "-v")) {
				debug = 1;
			}
			else if (!strcmp(argv[2], "-h")) {
				printf("Proper usage:\n");
				printf("calc <filename> [-v]\n");
				printf("Will read in a binary file and currently do nothing, use the verbose command for cool stuff\n");
				printf("add the flag -v for verbose output \n");
				return;
			}
		}
		// Check for valid file name
		char * filename = argv[1];
		if (debug){
			printf("Opening file: %s\n",filename);
		}
		in = fopen(filename,"r");
		if (in==NULL){
			printf("%sInvalid file name %s\n",KRED,filename);
			return;
		}
		fclose(in);
		// Check for valid extension
		const char * ext = getFilenameExt(filename);
		if (strcmp(ext,"jv")){
			printf("%sInvalid file extension %s\n",KRED,ext);
			return;
		}
		// Get number of instructions
		int instructions = fileLen(filename);
		if (instructions<0){
			printf("%sError please use the -v option for verbose logging\n",KRED);
			return;
		}
		if (debug){
			printf("There are %s%d%s instructions in the file %s%s%s\n",KGRN,instructions,KWHT,KCYN,filename,KWHT);
		}
		char bitList[instructions][8];
		struct Ins insList[instructions];
		// Get instructions
		if (debug){
			printf("Reading instructions from file\n\n");
		}
		if (readFile(filename, bitList, instructions))
			return;
		// Decode instructions
		if (decode(bitList,insList,instructions)){
			printf("Error invalid instructions in file\n");
			printf("Read error log for what caused the error\n");
			printf("Run the calc program with the -v option for verbose logging\n");
			printf("----------------------------------------------\n");
		}
		// If debugging, print out instructions read
		if (debug){
			printf("line#:\t\t|\t:Binary:\t|\top  r1 r2 r3 imm  extra\n");
			printf("----------------+-----------------------+---------------------------\n");
			for (int i = 0;i<instructions;i++){
				printf("ins %s%3d%s:\t|\t",KGRN,i,KWHT);
				for(int c=0;c<8;c++){
					printf("%s%c%s",KGRN,bitList[i][c],KWHT);
				}
				printf("\t|\t%s%s%s",KMAG,insList[i].op,KWHT);
				printf(" %s%s", KYEL,insList[i].r1);
				printf(" %s", insList[i].r2);
				printf(" %s%s", insList[i].r3,KWHT);
				printf(" %s%s", KBLU,insList[i].imm);
				printf(" %s%s", KWHT,insList[i].jmp);


				printf("\n");
			}
			printf("\n==============Now running instructions==============%s\n\n",KNRM);
		}
		int nextPC = 1;
		while (pc < instructions) {
			nextPC = 1;
			if (debug) {
				printf("PC:%s%3d%s ins: %s%s%s ", KGRN,pc,KWHT,KMAG,insList[pc].op,KWHT);
				printf(" %s%s",KYEL, insList[pc].r1);
				printf(" %s", insList[pc].r2);
				printf(" %s%s", insList[pc].r3,KBLU);
				printf(" %s%s", insList[pc].imm,KWHT);
				printf(" %s", insList[pc].jmp);
				printf(" | REG: %sr0%s=%s%3d%s | %sr1%s=%s%3d%s | %sr2%s=%s%3d%s | %sr3%s=%s%3d%s\n",KYEL,KWHT,KGRN,r0,KWHT, KYEL, KWHT, KGRN, r1, KWHT, KYEL, KWHT, KGRN, r2, KWHT, KYEL, KWHT, KGRN, r3, KNRM);
			}
			if (!strcmp(insList[pc].op, "lod\0")) {
				lod(insList[pc]);
			}
			else if (!strcmp(insList[pc].op, "add\0")) {
				add(insList[pc]);
			}
			else if (!strcmp(insList[pc].op, "sub\0")) {
				sub(insList[pc]);
			}
			else if (strcmp(insList[pc].op, "dsp\0")==0) {
				dsp(insList[pc]);
			}
			else if (!strcmp(insList[pc].op, "cmp\0")) {
				int jump = cmp(insList[pc]);
				if (debug)
					printf("PC += %d\n", jump+1);
				nextPC += jump;
			}
			else {
				printf("%sUnrecognized command %s on line %d ,terminating program\n",KRED,insList[pc].op,pc);
				return;
			}
			pc+=nextPC;
		}
	}
}
int decode(char bitList[][8],struct Ins insList[],int len){
	
	const char space[2] = " \0";
	for (int ins=0;ins<len;ins++){
		char opCode[3] = "  \0";
		char op[4] = "   \0";
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
				strncpy(jmp, "0", 1);
			}
			else if (!strcmp(extra,"01")){
				strncpy(op,"cmp",3);
				strncpy(jmp,"1",1);		
			}
			else if (!strcmp(extra,"10")){
				strncpy(op,"cmp",3);
				strncpy(jmp,"2",1);
			}
			else {
				printf("%sInvalid Command found %s with extra flag %s%s\n", KRED, opCode,extra, KWHT);
				return -1;
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
int readFile(char* filename, char bitList[][8],int len){
	FILE * fp = fopen(filename,"r");
	char bit;
	for (int ins = 0;ins<len;ins++){
		for (int pos = 0;pos<8;pos++){
			bit = fgetc(fp);
			if (bit != '\0')
			{
				bitList[ins][pos]=bit;
			}
			if (!(bit == '0' || bit == '1') && bit != '\0') {
				printf("%sInvalid character found in binary file: %c%s\n", KRED, bit, KNRM);
				return -1;
			}
		}
	}
	fclose(fp);
	return 0 ;
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
		if (!(ch == '0' || ch == '1') && !feof(fp)) {
			printf("%sInvalid character found in binary file: %c%s\n", KRED, ch, KNRM);
			return -2;
		}
	}
	if (c!=1){
		printf("%sMissing binary characters, should have 8 digits, instead you have %d on line:%d%s\n",KRED,c-1,ins+1,KWHT);
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

void binary(int8_t x,char bin[9]) {
	bin[8] = '\0';
	if (x < 0) {
		bin[0] = '1';
		x = x * -1;
	}
	else {
		bin[0] = '0';
	}
	int i = 7;
	while (i>0) {
		//printf("%d\n",i);
		bin[i] = (x % 2) + '0';
		x = x / 2;
		i--;
	}
	if (bin[0] == '1') {
		for (i = 1; i < 8; i++) {
			bin[i] = (bin[i] == '0') ? '1' : '0';
		}
		int carry = 0;
		if (bin[7] == '0') {
			bin[7] = '1';
			return;
		}
		else {
			bin[7] = '0';
			carry = 1;
		}
		for (i = 6; i > 0; i--) {
			if (carry) {
				if (bin[i] == '0') {
					bin[i] = '1';
					return;
				}
				else {
					bin[i] = '0';
				}
			}
		}
	}
}

void lod(struct Ins ins) {
	int immInt = 0;
	int isNeg = 0;
	int carry = 0;

	//check for negative
	if (ins.imm[0] == '1') {
		isNeg = 1;
	}//if

	 //two's compliment time
	if (isNeg == 1) {

		//First we flip
		for (int i = 3; i >= 0; i--) {
			if (ins.imm[i] == '1') {
				ins.imm[i] = '0';
			}//if

			else if (ins.imm[i] == '0') {
				ins.imm[i] = '1';
			}//else

		}//for

		 //now add one
		 //LSB == 0 case first
		if (ins.imm[3] == '0') {
			ins.imm[3] = '1';
		}//if

		 //Now if the LSB == 1
		else if (ins.imm[3] == '1') {
			ins.imm[3] = '0';
			carry = 1;
			int i = 2;

			//changing the bits as long as the carry == 1
			while ((carry == 1) && (i >= 0)) {

				if (ins.imm[i] == '1') {
					ins.imm[i] = '0';
					carry = 1;
				}//if

				else if (ins.imm[i] == '0') {
					ins.imm[i] = '1';
					carry = 0;

				}//else if
				i--;

			}//while

		}//else if

	}//if

	 //converting to decimal
	for (int i = 3; i >0; i--) {

		if (ins.imm[i] == '1') {
			immInt += ipow(2, 3 - i);
		}//if

	}//for

	 //handling MSB and negativity
	if (isNeg == 1) {
		if (strcmp(ins.imm, "1000") == 0) {
			immInt = 8;
		}//if
		immInt = 0 - immInt;
	}//if


	 //storing in appropriate register
	if (strcmp(ins.r1, "r0") == 0) {
		r0 = immInt;
	}//if r0

	else if (strcmp(ins.r1, "r1") == 0) {
		r1 = immInt;
	}//else if r1

	else if (strcmp(ins.r1, "r2") == 0) {
		r2 = immInt;
	}//else if r2

	else if (strcmp(ins.r1, "r3") == 0) {
		r3 = immInt;
	}//else if r3

}//lod 
void add(struct Ins ins) {
	int reg2;
	int reg3;
	int sum;

	if (strcmp(ins.r2, "r0") == 0) {
		reg2 = r0;
	}//if r0

	else if (strcmp(ins.r2, "r1") == 0) {
		reg2 = r1;
	}//else if r1

	else if (strcmp(ins.r2, "r2") == 0) {
		reg2 = r2;
	}//else if r2

	else if (strcmp(ins.r2, "r3") == 0) {
		reg2 = r3;
	}//else if r3

	if (strcmp(ins.r3, "r0") == 0) {
		reg3 = r0;
	}//if r0

	else if (strcmp(ins.r3, "r1") == 0) {
		reg3 = r1;
	}//else if r1

	else if (strcmp(ins.r3, "r2") == 0) {
		reg3 = r2;
	}//else if r2

	else if (strcmp(ins.r3, "r3") == 0) {
		reg3 = r3;
	}//else if r3

	sum = reg2 + reg3;

	if (strcmp(ins.r1, "r0") == 0) {
		r0 = sum;
	}//if r0

	else if (strcmp(ins.r1, "r1") == 0) {
		r1 = sum;
	}//else if r1

	else if (strcmp(ins.r1, "r2") == 0) {
		r2 = sum;
	}//else if r2

	else if (strcmp(ins.r1, "r3") == 0) {
		r3 = sum;
	}//else if r3


}//add 
void sub(struct Ins ins) {
	int reg2;
	int reg3;
	int dif;

	if (strcmp(ins.r2, "r0") == 0) {
		reg2 = r0;
	}//if r0

	else if (strcmp(ins.r2, "r1") == 0) {
		reg2 = r1;
	}//else if r1

	else if (strcmp(ins.r2, "r2") == 0) {
		reg2 = r2;
	}//else if r2

	else if (strcmp(ins.r2, "r3") == 0) {
		reg2 = r3;
	}//else if r3

	if (strcmp(ins.r3, "r0") == 0) {
		reg3 = r0;
	}//if r0

	else if (strcmp(ins.r3, "r1") == 0) {
		reg3 = r1;
	}//else if r1

	else if (strcmp(ins.r3, "r2") == 0) {
		reg3 = r2;
	}//else if r2

	else if (strcmp(ins.r3, "r3") == 0) {
		reg3 = r3;
	}//else if r3

	dif = reg2 - reg3;

	if (strcmp(ins.r1, "r0") == 0) {
		r0 = dif;
	}//if r0

	else if (strcmp(ins.r1, "r1") == 0) {
		r1 = dif;
	}//else if r1

	else if (strcmp(ins.r1, "r2") == 0) {
		r2 = dif;
	}//else if r2

	else if (strcmp(ins.r1, "r3") == 0) {
		r3 = dif;
	}//else if r3


}//dif
void dsp(struct Ins ins) {
	char bin[9];
	if (strcmp(ins.r1, "r0") == 0) {
		binary(r0, bin);
		printf("%4d : %s\n", r0,bin);
	}//if r0

	else if (strcmp(ins.r1, "r1") == 0) {
		binary(r1, bin);
		printf("%4d : %s\n", r1,bin);
	}//else if r1

	else if (strcmp(ins.r1, "r2") == 0) {
		binary(r2, bin);
		printf("%4d : %s\n", r2, bin);
	}//else if r2

	else if (strcmp(ins.r1, "r3") == 0) {
		binary(r3, bin);
		printf("%4d : %s\n", r3, bin);
	}//else if r3
}//dsp
int cmp(struct Ins ins) {
	int reg1;
	int reg2;
	int jump;

	if (!strcmp(ins.jmp, "1")) {
		jump = 1;
	}
	else if (!strcmp(ins.jmp, "2")) {
		jump = 2;
	}//else if 

	 //set reg1 val
	if (strcmp(ins.r1, "r0") == 0) {
		reg1 = r0;
	}//if r0

	else if (strcmp(ins.r1, "r1") == 0) {
		reg1 = r1;
	}//else if r1

	else if (strcmp(ins.r1, "r2") == 0) {
		reg1 = r2;
	}//else if r2

	else if (strcmp(ins.r1, "r3") == 0) {
		reg1 = r3;
	}//else if r3

	 //set reg2 val
	if (strcmp(ins.r2, "r0") == 0) {
		reg2 = r0;
	}//if r0

	else if (strcmp(ins.r2, "r1") == 0) {
		reg2 = r1;
	}//else if r1

	else if (strcmp(ins.r2, "r2") == 0) {
		reg2 = r2;
	}//else if r2

	else if (strcmp(ins.r2, "r3") == 0) {
		reg2 = r3;
	}//else if r3

	 //comparison time
	if (reg1 != reg2) {
		return 0;
	}//if

	else if (reg1 == reg2) {
		return jump;
	}//if

}//cmp
int ipow(int base, int exp) {
	int result = 1;
	while (exp) {
		if (exp & 1)
			result *= base;
		exp >>= 1;
		base *= base;
	}//while

	return result;
}//ipow