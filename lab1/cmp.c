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



int r0=0;
int r1=0;
int r2=0;
int r3=0;
int pc=0;

int cmp(struct Ins ins);

void main(int argc, char *argv[]){

	struct Ins ins;	
	
	r0=1;
	r1=2;
	r2=3;
	r3=4;
	
	strcpy(ins.r1,"r0");
	strcpy(ins.r2,"r0");
	strcpy(ins.jmp,"1");
	
	printf("%d",cmp(ins));
	
}//main

int cmp(struct Ins ins){
	int reg1;
	int reg2;
	int jump;

	if (strcmp(ins.jmp,"1")){
		jump = 1;
	}
	else if(strcmp(ins.jmp,"2")){
		jump = 2;
	}//else if 

	//set reg1 val
	if (strcmp(ins.r1,"r0") == 0){
		reg1 = r0;
	}//if r0
	
	else if (strcmp(ins.r1,"r1") == 0){
		reg1 = r1;
	}//else if r1
	
	else if (strcmp(ins.r1,"r2") == 0){
		reg1 = r2;
	}//else if r2
	
	else if (strcmp(ins.r1,"r3") == 0){
		reg1 = r3;
	}//else if r3

	//set reg2 val
	if (strcmp(ins.r2,"r0") == 0){
		reg2 = r0;
	}//if r0
	
	else if (strcmp(ins.r2,"r1") == 0){
		reg2 = r1;
	}//else if r1
	
	else if (strcmp(ins.r2,"r2") == 0){
		reg2 = r2;
	}//else if r2
	
	else if (strcmp(ins.r2,"r3") == 0){
		reg2 = r3;
	}//else if r3

	//comparison time
	if (reg1 != reg2){
		return 0;
	}//if

	else if (reg1 == reg2){
		return jump;
	}//if
	
}//cmp
